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


class DiscussionsController < ApplicationController

  before_filter :authenticate_user!
  
  # Using the logic inside method instead
  #before_action :gplus_login, only: [:create]
  #after_action :after_do, only: [:create]

  # GET
  # NOTE: using jbuilder 
  def index
  	discussions = Discussion.whole_company(current_user.account_id)
    @discussions = discussions.as_json(:include => :user)
  end

  # GET
  def show
  end

  # POST
  # it posts into internal DB, and then if such option is enabled also posts to Google+ Domain
  def create_discussion
    create(nil)
  end

  # POST
  # create new product review
  def create_review
    create(params[:product_id])
  end

private

  # Create a new discussion or review
  # if product_id is not null, then it's a prodcut review
  def create(product_id)

    # Post internally
    new_discussion = Discussion.new
    new_discussion.title = params[:title]
    new_discussion.product_id = product_id
    current_user.discussions << new_discussion

    #Post to Google+ if enabled
    @account = current_user.account
    if !@account.blank? && !@account.options.blank? 
      @options = ActiveSupport::JSON.decode(@account.options)
      if @options['discussions'] == 'gplus'
        gplus_login
        if !@gplus_client.nil?
          json_payload = { 
            "object" => {
                "originalContent" => new_discussion.title
              },
            "access" => {
              "items" => [{ "type" => "domain" }],
              "domainRestricted" => true
            }
          }
          result = @gplus_client.execute(
            :api_method => @gplus_domain_api.activities.insert, 
            :headers => {'Content-Type' => 'application/json'},
            :parameters => { 'userId' => 'me' },
            :body_object => json_payload
          )
        end
      end
    end
  
    # Return result
    @result = {}
  end

  # Gplus+ login uses service account authentication
  def gplus_login

    @gplus_client = nil

    begin
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
    rescue Signet::AuthorizationError => err
      logger.debug('Gplus result: status: ' + err.to_s)
    ensure
      Google::APIClient.logger.level = Logger::INFO
    end

  end

  def user_credentials
    # Build a per-request oauth credential based on token stored in session
    # which allows us to use a shared API client.

    if !@gplus_client.nil?
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

  # This method retrieves G+ discussions
  def gplus_discussions

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

end
