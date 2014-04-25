class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  # GET
  def index
    u = User.find_by_email(current_user.email)

    # --- Company section
    @account = u.account

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
    if request.format.symbol == :html
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
        json_result['account'] = @account
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
    u = User.find_by_email(current_user.email)
    pl = Playlist.find(params[:playlist_id])
    # TODO handle exceptions
    u.playlists << pl
    result = { 'user_ud' => u.id, 'playlist_id' => params[:playlist_id] }

    respond_to do |format|
        format.json { render json: result.as_json }
    end
    
  end

  # DELETE :id
  # unsubscribe currently authenitcated user from the playlist
  # JSON: empty
  def unsubscribe
    u = User.find_by_email(current_user.email)
    pl = Playlist.find(params[:id])
    # TODO handle exceptions
    u.playlists.delete(pl)
    result = { 'user_ud' => u.id, 'playlist_id' => pl.id }

    respond_to do |format|
        format.json { render json: result.as_json }
    end
    
  end


end
