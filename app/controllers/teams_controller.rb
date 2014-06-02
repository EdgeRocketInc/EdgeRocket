class TeamsController < ApplicationController

  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    u = current_user
    account = u.account
    @users = account ? account.users : nil
  end

end