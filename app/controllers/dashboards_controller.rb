class DashboardsController < ApplicationController
  before_action :set_dashboard, only: [:show]
  before_filter :authenticate_user!

  # GET /dashboard
  # GET /dashboard.json
  # NOTE: it uses a jbuilder view
  def show

    authorize! :manage, :all

  	@users = { 
  		:total_count => User.where(:account_id => current_user.account_id).count, 
  		:num_admins => User.joins(:roles).where("users.account_id=? and roles.name in ('SA','Admin')", current_user.account_id).count
  	}
   
    @account = current_user.account
    @group_count = MyCourse.joins(:user).where("users.account_id=?", @account.id).group(:status).count

    publish_keen_io(:html, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name,
        :request_format => request.format.symbol
      }
    )

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
