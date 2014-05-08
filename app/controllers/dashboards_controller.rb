class DashboardsController < ApplicationController
  before_action :set_dashboard, only: [:show]
  before_filter :authenticate_user!

  # GET /dashboard
  # GET /dashboard.json
  # NOTE: it uses a jbuilder view
  def show
  	@users = { 
  		:total_count => User.count, 
  		:num_admins => Role.count("name in ('Admin', 'SA')")
  	}

  	authorize! :manage, :all

    @account = current_user.account
    @group_count = MyCourses.group(:status).count

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
      params[:dashboard]
    end
end
