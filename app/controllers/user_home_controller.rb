class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  # GET .html
  def index
    publish_keen_io(:html, :ui_actions, {
      :user_email => current_user.email,
      :action => controller_path,
      :method => action_name,
      :user_agent => request.env['HTTP_USER_AGENT'] # TODO: use UserAgent gem
    })

    #byebug

    # if this is a linkedin user, try to use her profile to get interest
    if current_user.provider == 'linkedin' && current_user.survey.nil?
      survey_linkedin_skills()
    end
    
    # render the interests page only if
    # user has not done the survey AND does not have incomplte courses

    if current_user.survey.nil? && current_user.count_incomplete_courses() == 0
      render 'interests'
    else
      render 'index_v2'
    end

  end

  # GET .html
  def user_playlists
    publish_keen_io(:html, :ui_actions, {
      :user_email => current_user.email,
      :action => controller_path,
      :method => action_name,
    })
  end

  # GET .json
  def user_playlists_json
    u = current_user

    # --- Company section
    @account = u.account

    # --- Discussion section

    # --- Playlists section
    @playlists = @account ? @account.playlists.order('title') : nil

    @subscribed_playlists = Hash.new()

    if @playlists
      @playlists.each { |pl|
        # find out if each playlist is subscribed by this user, and store that
        # inside a hash
        if pl.subscribed?(u.id)
          @subscribed_playlists[pl.id] = true
        end
      }
    end

    publish_keen_io(:json, :ui_actions, {
      :user_email => current_user.email,
      :action => controller_path,
      :method => action_name,
    })

    respond_to do |format|
      format.json {
        # combine all objects into one JSON result
        json_result = Hash.new()
        json_result['playlists'] = @playlists.as_json(:include => :playlist_items)
        json_result['subscribed_playlists'] = @subscribed_playlists
        render json: json_result.as_json
      }
    end

  end

  # POST
  # subscribe currently authenitcated user to playlists
  # JSON: "playlist_ids" : [1003, 1004]
  def subscribe

    new_courses = false
    #byebug

    u = current_user
    pls = Playlist.find(params[:playlist_ids])
    # TODO handle exceptions
    u.playlists << pls

    # subscribe for all courses in this playlists
    for pl in pls
      for product in pl.products
        if MyCourse.subscribe(u.id, product.id, 'reg', 'Self')
          new_courses = true
        end
      end
    end

    # set user flag to indicate new courses
    if new_courses
      u.update(new_courses: true, ui_message_id: UiMessage::MSG_NEW_COURSE_SUB)
    end

    result = {'user_id' => u.id, 'playlist_ids' => params[:playlist_ids]}

    respond_to do |format|
      format.json { render json: result.as_json }
    end

  end

  # DELETE :id
  # unsubscribe currently authenitcated user from the playlist
  # optional parameter :cascade
  # JSON: empty
  def unsubscribe
    u = current_user
    pl = Playlist.find(params[:id])

    #byebug

    # unsubscribe for all courses in this playlists
    if params[:cascade] != false && params[:cascade] != 'false'
      for product in pl.products
        MyCourse.unsubscribe(u.id, product.id)
      end
    end

    # TODO handle exceptions
    u.playlists.delete(pl)
    result = {'user_ud' => u.id, 'playlist_id' => pl.id}

    respond_to do |format|
      format.json { render json: result.as_json }
    end
  end

  # POST
  # create a new set of user preferences for current user
  # JSON: {anything}
  def create_preferences
  
    skills_to_send, prefs = make_skills(params[:skills])

    create_preferences_impl skills_to_send, prefs, UiMessage::MSG_NEW_COURSE_RECOMMEND

    result = {'user_id' => current_user.id}

    render json: result.as_json

  end

  # PATCH
  # update new set of user preferences for current user
  # JSON: {anything}
  def patch_preferences

    # if survey exists, updated it, else create a new one
    if current_user.survey
      skills_to_send, prefs = make_skills(params[:skills])
      current_user.survey.update(preferences: prefs.to_json)
      recommendations_hash = RecommendationsEmail.save_recommendations_email(current_user, skills_to_send, current_user.survey.id)
      # assign recommended courses to the user and set a flag to indicate that user has new courses
      assign_recommended_courses(
        current_user, 
        recommendations_hash, 
        UiMessage::MSG_NEW_COURSE_RECOMMEND)
      result = {'user_id' => current_user.id}
      render json: result.as_json
    else
      create_preferences
    end

  end

  # GET
  # obtains current user's information
  def get_user
    u = current_user
    @account = u.account

    respond_to do |format|
      format.json {
        # combine all objects into one JSON result
        json_result = u.as_json(:include => :ui_message)
        json_result['account'] = @account.as_json(methods: :options)
        json_result['sign_in_count'] = u.sign_in_count #ugly but works
        unless u.survey == nil
          json_result['user_preferences'] = u.survey.preferences #ugly but works
        end
        json_result['best_role'] = u.best_role
        render json: json_result.as_json
      }
    end
  end

private

  # the recommendations are in format: [11, [100, 201]] where 11 is a skill and [100, 201] are recommendation product ids
  def assign_recommended_courses(user, recommendations, ui_message_id)
    new_courses = false
    recommendations.each { |recommendation|
      #byebug
      if !recommendation[1].nil?
        recommendation[1].each { |product_id|
          is_subscribed = MyCourse.subscribe(user.id, product_id, 'wish', 'Self')
          if new_courses == false
            new_courses = is_subscribed
          end
        }
      end
    }

    # set user flag to indicate new courses
    if new_courses
      user.update(new_courses: true, ui_message_id: ui_message_id)
    end

  end

  def make_skills(skills_source)

    skills_to_send = []

    prefs = {:skills => skills_source} # TODO make it real
    if !skills_source.nil?
      preferred_skills = skills_source.map do |skill|
        if skill['id'] != 'other_skill'
          Skill.find_a_match(skill['id'])
        end
      end.compact

      preferred_skills.each do |skill|
        if !skill.recommendations.nil? &&  !skill.recommendations.empty?
          skills_to_send << skill.id
        end
      end
    end

    return skills_to_send.uniq, prefs
  end

  def create_preferences_impl(skills_to_send, prefs, ui_message_id)
    survey = Survey.new(
      user_id: current_user.id,
      preferences: prefs.to_json)
    
    current_user.survey = survey
    if !skills_to_send.empty? && !skills_to_send.nil?
      survey.update!( {:processed => true} )
      
      recommendations_hash = RecommendationsEmail.save_recommendations_email(current_user, skills_to_send, survey.id)
      Notifications.send_recommendations(current_user, request.protocol + request.host_with_port, skills_to_send).deliver

      # assign recommended courses to the user and set a flag to indicate that user has new courses
      assign_recommended_courses(current_user, recommendations_hash, ui_message_id)

    end
    Notifications.survey_completed(current_user).deliver
  end

  # analyze linkedin skills of the user and save them in leu of survey
  def survey_linkedin_skills()
    skills_survey = []
    skills_data = nil
    
    begin
      skills_data = RestClient.get(
        "https://api.linkedin.com/v1/people/~:(skills)?format=json", 
        { 'Authorization' => "Bearer #{current_user.access_token}" } )
    rescue RestClient::Unauthorized => e
      # not much we can do here
    end

    if !skills_data.nil?
      skills_json = JSON.parse(skills_data)
      # LinkedIn skills top section contains 10 elements, 
      # therefore use last 3 of that or last 3 if there are fewer than 10
      if !skills_json['skills'].nil?
        skills_bottom = skills_json['skills']['_total'] > 10 ? 9 : skills_json['skills']['_total']
        if skills_bottom > 0
          skills_count =  skills_bottom > 1 ? 3 : skills_bottom
          for i in (skills_bottom-skills_count+1)..skills_bottom
            skill_name = skills_json['skills']['values'][i]['skill']['name']
            if !skill_name.blank?
              # try to match this linkedin skill to the list of internal skills we have
              matching_er_skill = Skill.find_a_match(skill_name.downcase)
              if !matching_er_skill.nil?
                skills_survey.push( { 'id' => matching_er_skill.key_name } ) 
              end
            end
          end
        end
        #byebug
        skills_to_send, prefs = make_skills skills_survey
        create_preferences_impl(
          skills_to_send, prefs, UiMessage::MSG_NEW_LI_RECOMMEND )
      end
    end
  end

end
