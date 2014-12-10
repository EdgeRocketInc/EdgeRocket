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

    # if user has not done the survey, render the interests page
    if current_user.survey.nil?
      # TODO
      #render 'interests'
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
      # find out if each playlist is subscribed by this user, and store that
      # inside a hash
      @playlists.each { |pl|
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
        json_result['playlists'] = @playlists
        json_result['subscribed_playlists'] = @subscribed_playlists
        render json: json_result.as_json
      }
    end

  end

  # POST
  # subscribe currently authenitcated user to the playlist
  # JSON: {"playlist_id":"1003"}
  def subscribe

    #debugger

    u = current_user
    pl = Playlist.find(params[:playlist_id])
    # TODO handle exceptions
    u.playlists << pl

    # subscribe for all courses in this playlists
    for product in pl.products
      MyCourse.subscribe(u.id, product.id, 'reg', 'Self')
    end

    result = {'user_ud' => u.id, 'playlist_id' => params[:playlist_id]}

    respond_to do |format|
      format.json { render json: result.as_json }
    end

  end

  # DELETE :id
  # unsubscribe currently authenitcated user from the playlist
  # JSON: empty
  def unsubscribe
    u = current_user
    pl = Playlist.find(params[:id])

    # unsubscribe for all courses in this playlists
    for product in pl.products
      MyCourse.unsubscribe(u.id, product.id)
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

    prefs = {:skills => params[:skills]} # TODO make it real
    if !params[:skills].nil?
      preferred_skills = params[:skills].map do |skill|
        if skill["id"] != "other_skill"
          Skill.find_by_key_name(skill["id"])
        end
      end.compact
      skills_to_send = []

      preferred_skills.each do |skill|
        if !skill.recommendations.nil? &&  !skill.recommendations.empty?
          skills_to_send << skill.id
        end
      end
    end

    survey = Survey.new(
      user_id: current_user.id,
      preferences: prefs.to_json)
    
    if survey.save
      if !skills_to_send.empty? && !skills_to_send.nil?
        survey.update!( {:processed => true} )
        RecommendationsEmail.save_recommendations_email(current_user, skills_to_send, survey.id)
        Notifications.send_recommendations(current_user, request.protocol + request.host_with_port, skills_to_send).deliver
      end
      Notifications.survey_completed(current_user).deliver
    end

    result = {'user_id' => current_user.id}

    render json: result.as_json

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

end
