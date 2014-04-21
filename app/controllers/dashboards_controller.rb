class DashboardsController < ApplicationController
  before_action :set_dashboard, only: [:show]
  before_filter :authenticate_user!

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
	@users = { 
		:total_count => User.count, 
		:num_admins => Role.count("name in ('Admin', 'SA')")
	}

	authorize! :manage, :all
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
