require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'

PLUS_LOGIN_SCOPE = 
  ['https://www.googleapis.com/auth/plus.circles.read', 
  'https://www.googleapis.com/auth/plus.circles.write', 
  'https://www.googleapis.com/auth/plus.me', 
  'https://www.googleapis.com/auth/plus.media.upload', 
  'https://www.googleapis.com/auth/plus.stream.read', 
  'https://www.googleapis.com/auth/plus.stream.write']
#CREDENTIAL_STORE_FILE = "gplus-oauth2.json"

class UserHomeController < ApplicationController
  before_filter :authenticate_user!
  before_action :gplus_login
  after_action :after_do

  # GET
  def index

    u = current_user

    # --- Company section
    @account = u.account

    # --- Discussions section

    # --- Playlists section
    @playlists = @account ? @account.playlists : nil

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

    #TODO make it async
    if !Rails.env.test? && request.format.symbol == :html
      Keen.publish(:ui_actions, {
        :user_email => u.email,
        :action => controller_path,
        :method => action_name,
        :request_format => request.format.symbol
      })
    end

    respond_to do |format|
      format.html
      format.json {
        # combine all aobject into one JSON result
        json_result = Hash.new()
        json_result['account'] = @account.as_json(methods: :options)
        json_result['playlists'] = @playlists
        json_result['subscribed_playlists'] = @subscribed_playlists
        json_result['sign_in_count'] = u.sign_in_count #ugly but works
        json_result['user_preferences'] = u.preferences #ugly but works
        render json: json_result.as_json
      }
    end
  end

  # POST
  # subscribe currently authenitcated user to the playlist
  # JSON: {"playlist_id":"1003"}
  def subscribe
    u = current_user
    pl = Playlist.find(params[:playlist_id])
    # TODO handle exceptions
    u.playlists << pl

    # subscribe for all courses in this playlists
    for product in pl.products
      MyCourses.subscribe(u.id, product.id, 'reg', 'Self')
    end

    result = { 'user_ud' => u.id, 'playlist_id' => params[:playlist_id] }

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
      MyCourses.unsubscribe(u.id, product.id)
    end

    # TODO handle exceptions
    u.playlists.delete(pl)
    result = { 'user_ud' => u.id, 'playlist_id' => pl.id }

    respond_to do |format|
        format.json { render json: result.as_json }
    end
  end

  # POST
  # create new set of user preferences
  # JSON: {anything}
  def create_preferences
    u = current_user.email
    #debugger
    u.preferences = params[:education].to_json # TODO make it real
    u.save

    result = { 'user_ud' => u.id }

    respond_to do |format|
        format.json { render json: result.as_json }
    end
  end

  # Google+ API authorization redirect
  def oauth2authorize
    # Request authorization
    redirect_to user_credentials.authorization_uri.to_s, status: 303
  end

  # Google+ API authorization callback
  def oauth2callback
    # Exchange token
    user_credentials.code = params[:code] if params[:code]
    user_credentials.fetch_access_token!
    redirect_to(action: 'index')
  end

  def list_discussions

    @discussions = []
    result = @gplus_client.execute(
      :api_method => @gplus_domain_api.activities.list, 
      :headers => {'Content-Type' => 'application/json'},
      :parameters => { 'userId' => 'me', 'collection' => 'user', 'maxResults' => 3 },
      :authorization => @authorization
    )

    #debugger
    if result.status == Rack::Utils.status_code(:ok)
      json_body = JSON.parse(result.body)
      json_body['items'].each { |item|
        # If a post title contains #edgerocket hash tag, we want to use it
        # NOTE: not the best way to make it case insensitive
        if item['title'].downcase.include? '#edgerocket'
          @discussions << item
        end
      }
    end
    #debugger
    logger.debug('Gplus result: status: ' + result.status.to_s)

  end


private

  def gplus_login

    @account = current_user.account
    if !@account.blank? && !@account.options.blank? 
      options = ActiveSupport::JSON.decode(@account.options)
      if options['discussions'] == true
        Google::APIClient.logger.level = Logger::DEBUG

        # TODO use proper version constants
        gplus_client = Google::APIClient.new(:application_name => 'EdgeRocket', :application_version => '0.1.0')

        #file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
        #if file_storage.authorization.nil?
          gplus_client_secrets = Google::APIClient::ClientSecrets.load
          gplus_client.authorization = gplus_client_secrets.to_authorization
          gplus_client.authorization.scope = PLUS_LOGIN_SCOPE
        #else
        #  gplus_client.authorization = file_storage.authorization
        #end

        @gplus_domain_api = gplus_client.discovered_api('plusDomains')

        @gplus_client = gplus_client

        unless user_credentials.access_token || request.path_info =~ /^\/oauth2/
          redirect_to(action: 'oauth2authorize')
        end
      end
    end

  end

  def user_credentials
    # Build a per-request oauth credential based on token stored in session
    # which allows us to use a shared API client.

    @authorization ||= (

      gplus_client = @gplus_client
      auth = gplus_client.authorization.dup
      auth.redirect_uri = url_for(:action => 'oauth2callback')
      auth.update_token!( 
        :access_token => session[:access_token],
        :refresh_token => session[:refresh_token]
      )
      #debugger
      auth
    )

  end

  def after_do
    # Serialize the access/refresh token to the session and credential store.

    #debugger
    session[:access_token] = user_credentials.access_token
    session[:refresh_token] = user_credentials.refresh_token
    session[:expires_in] = user_credentials.expires_in
    session[:issued_at] = user_credentials.issued_at

    #file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
    #file_storage.write_credentials(user_credentials)
  end

end
