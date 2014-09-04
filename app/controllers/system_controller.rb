class SystemController < ApplicationController

  before_filter :ensure_sysop_user

  def surveys
    @survey = Survey.order(created_at: :asc)
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