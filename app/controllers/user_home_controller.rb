class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    u = User.find_by_email(current_user.email)

    # --- Playlists section
    @my_playlists = u.playlists
  end
end
