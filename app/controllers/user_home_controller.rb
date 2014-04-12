class UserHomeController < ApplicationController
  before_filter :authenticate_user!

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

end
