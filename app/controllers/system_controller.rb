class SystemController < ApplicationController

  before_filter :ensure_sysop_user
  layout "system"

  def surveys
    @unprocessed_surveys = Survey.where(processed: false)
    @processed_surveys = Survey.where(processed: true)
  end

  def one_survey
    @survey = Survey.find(params["id"])
    render json: @survey.preferences
  end

  def processing
    @survey = Survey.find(params["id"])
    @survey.update!({:processed => true})
    render json: @survey
  end

  def undo_processing
    @survey = Survey.find(params["id"])
    @survey.update!({:processed => false})
    render json: @survey
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