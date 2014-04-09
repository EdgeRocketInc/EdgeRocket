class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    u = User.find_by_email(current_user.email)

    # --- Compnay section
    @account = u.account

    # --- Playlists section
    @my_playlists = u.account ? Playlist.all_for_company(u.account.id) : nil
  end
end
