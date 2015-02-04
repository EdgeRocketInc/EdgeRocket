class CompanyController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  # JSON only, see jbuilder
  def account
    @account = current_user.account
  end

  # JSON only
  def update_account

    account_id = params[:id]

    new_overview = params[:overview]
    Account.update(account_id, :overview => new_overview)
    result = {'id' => account_id}

    respond_to do |format|
      format.json { render json: result.as_json }
    end
  end

  def disable_company
    company = Account.find(params["id"])
    company.update(:disabled => true)
    #disable_users(company)

    render json: company

  end

  def activate_company
    company = Account.find(params["id"])
    company.update(:disabled => false)
    #activate_users(company)
    render json: company
  end

  private

  def activate_users(company)
    company.users.each do |user|
      user.update(:is_active => true)
    end
  end

  def disable_users(company)
    company.users.each do |user|
      user.update(:is_active => false)
    end
  end
end
