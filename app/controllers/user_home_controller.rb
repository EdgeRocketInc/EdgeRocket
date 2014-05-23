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
KEY_FILE = 'privatekey-gplus.p12'
KEY_SECRET = 'notasecret'
CLIENT_EMAIL = '185907991513-pdaqveuql5ia5il5q2mspscnkq4393f2@developer.gserviceaccount.com'

class UserHomeController < ApplicationController
  before_filter :authenticate_user!
  before_action :gplus_login, only: [:index, :list_discussions]
  after_action :after_do, only: [:index, :list_discussions]

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
      @options = ActiveSupport::JSON.decode(@account.options)
      if @options['discussions'] == 'gplus'
        Google::APIClient.logger.level = Logger::DEBUG

        # TODO use proper version constants
        gplus_client = Google::APIClient.new(:application_name => 'EdgeRocket', :application_version => '0.1.0')
        
        # Load private key
        private_key = Google::APIClient::KeyUtils.load_from_pkcs12(KEY_FILE, KEY_SECRET)

        client_asserter = Google::APIClient::JWTAsserter.new(
            CLIENT_EMAIL,
            PLUS_LOGIN_SCOPE,
            private_key
        )
        gplus_client.authorization = client_asserter.authorize(current_user.email)

        @gplus_domain_api = gplus_client.discovered_api('plusDomains')

        @gplus_client = gplus_client
      end
    end

  end

  def user_credentials
    # Build a per-request oauth credential based on token stored in session
    # which allows us to use a shared API client.

    @authorization ||= (

      gplus_client = @gplus_client
      auth = gplus_client.authorization.dup
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

    if !@options.blank? && @options['discussions'] == 'gplus'
      #debugger
      session[:access_token] = user_credentials.access_token
      session[:refresh_token] = user_credentials.refresh_token
      session[:expires_in] = user_credentials.expires_in
      session[:issued_at] = user_credentials.issued_at
    end

  end

end
