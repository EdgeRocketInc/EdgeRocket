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
      u.update(new_courses: true)
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
  # create new set of user preferences for current user
  # JSON: {anything}
  def create_preferences
  
    skills_to_send, prefs = make_skills()

    survey = Survey.new(
      user_id: current_user.id,
      preferences: prefs.to_json)
    
    current_user.survey = survey
    if !skills_to_send.empty? && !skills_to_send.nil?
      survey.update!( {:processed => true} )
      
      recommendations_hash = RecommendationsEmail.save_recommendations_email(current_user, skills_to_send, survey.id)
      Notifications.send_recommendations(current_user, request.protocol + request.host_with_port, skills_to_send).deliver

      # assign recommended courses to the user and set a flag to indicate that user has new courses
      assign_recommended_courses(current_user, recommendations_hash)

    end
    Notifications.survey_completed(current_user).deliver

    result = {'user_id' => current_user.id}

    render json: result.as_json

  end

  # PATCH
  # update new set of user preferences for current user
  # JSON: {anything}
  def patch_preferences

    # if survey exists, updated it, else create a new one
    if current_user.survey
      skills_to_send, prefs = make_skills()
      current_user.survey.update(preferences: prefs.to_json)
      recommendations_hash = RecommendationsEmail.save_recommendations_email(current_user, skills_to_send, current_user.survey.id)
      # assign recommended courses to the user and set a flag to indicate that user has new courses
      assign_recommended_courses(current_user, recommendations_hash)
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
        json_result = u.as_json
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
  def assign_recommended_courses(user, recommendations)
    new_courses = false
    recommendations.each { |recommendation|
      #byebug
      if !recommendation[1].nil?
        recommendation[1].each { |product_id|
          new_courses = MyCourse.subscribe(user.id, product_id, 'wish', 'Self')
        }
      end
    }

    # set user flag to indicate new courses
    if new_courses
      user.update(new_courses: true)
    end

  end

  def make_skills()

    skills_to_send = []

    prefs = {:skills => params[:skills]} # TODO make it real
    if !params[:skills].nil?
      preferred_skills = params[:skills].map do |skill|
        if skill["id"] != "other_skill"
          Skill.find_by_key_name(skill["id"])
        end
      end.compact

      preferred_skills.each do |skill|
        if !skill.recommendations.nil? &&  !skill.recommendations.empty?
          skills_to_send << skill.id
        end
      end
    end

    return skills_to_send, prefs
  end

end
