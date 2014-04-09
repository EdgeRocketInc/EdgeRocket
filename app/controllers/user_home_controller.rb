class UserHomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    u = User.find_by_email(current_user.email)

    # --- Compnay section
    @account = u.account

    # --- Playlists section
    @playlists = @account ? @account.playlists : nil
    @playlists.each { |pl|
      pl.calc_fields
    }

  end
end
