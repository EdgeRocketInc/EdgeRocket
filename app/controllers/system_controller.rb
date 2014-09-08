class SystemController < ApplicationController

  before_filter :ensure_sysop_user
  layout "system"

  def surveys
    @surveys = Survey.order(created_at: :asc)
    respond_to do |format|
      format.html
      format.json {render json: @surveys}
    end
  end

  def pending_users
    @pending_users = PendingUser.all
  end

  private

  def ensure_sysop_user
    if current_user
      redirect_to root_path unless current_user.best_role == :sysop
    else
      redirect_to root_path
    end
  end

end