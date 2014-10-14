class SystemController < ApplicationController

  before_filter :ensure_sysop_user
  layout "system"

  def surveys
    @unprocessed_surveys = Survey.where(processed: false)
    @processed_surveys = Survey.where(processed: true)
  end

  def one_survey
    @recommendations = nil
    prefs = nil
    @survey = Survey.find(params["id"])
    if @survey
      if @survey.recommendations_email
        @recommendations = @survey.recommendations_email.recommendation
      end
      prefs = ActiveSupport::JSON.decode(@survey.preferences)
    end    
    @response_json = {
      skills: prefs['skills'],
      recommendations: @recommendations.nil? ? nil : ActiveSupport::JSON.decode(@recommendations) 
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

  def update_company
    @account = Account.find(params[:id])
    @account.update!(company_params)

    render json: @account
  end

  # Create User from pending user
  def create_user_from_pending
    @new_user = User.new
  end

  def reports
    @report = Report.new

    render json: @report.render
  end

  private

  def company_params
    params.require(:company).permit(:company_name, :options, :overview, :domain, :account_type)
  end
end