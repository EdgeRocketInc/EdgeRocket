class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    u = User.find_by_email(current_user.email)

    # --- Compnay section
    @account = u.account

    # --- Playlists section
    @playlists = @account ? @account.playlists : nil

    if @playlists
      # find out if each playlist is subscribed by this user, and store that
      # inside the playlist
      @playlists.each { |pl|
        pl.calc_subscribed(u.id)
      }
    end

  end
end
