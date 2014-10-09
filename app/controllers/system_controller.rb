class SystemController < ApplicationController

  before_filter :ensure_sysop_user
  layout "system"

  def surveys
    @unprocessed_surveys = Survey.where(processed: false)
    @processed_surveys = Survey.where(processed: true)
  end

  def one_survey
    @survey = Survey.find(params["id"])
    @recommendations = @survey.recommendations_email.recommendation
    prefs = ActiveSupport::JSON.decode(@survey.preferences)
    @response_json = {
      skills: prefs['skills'],
      recommendations: ActiveSupport::JSON.decode(@recommendations)
    }
    # not using jbuilder at this time
    render json: @response_json.as_json
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

  def companies
    @companies = Account.all

  end

  # Create User from pending user
  def create_user_from_pending
    @new_user = User.new
  end



end