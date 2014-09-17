class PendingUsersController < ApplicationController

  layout "sign_up"

  def new
    @pending_user = PendingUser.new
  end

  def create
    @pending_user = PendingUser.new(allowed_params)
    blank_company(@pending_user)
    if passwords_match? && @pending_user.save
      Notifications.account_requested(@pending_user).deliver
      Notifications.account_request_received(@pending_user, request.host_with_port).deliver
      flash[:notice] = "Thank you for your interest. We will contact you shortly."
      redirect_to root_path
    else
      render_error_messages(@pending_user)
      render :new
    end

  end

  def create_user_from_pending
    @pending_user = PendingUser.find_by(id: params["id"])
    account_exists = Account.find_by(:company_name => @pending_user.company_name)
    if account_exists

      @user = User.new(:account_id => account_exists.id, :email => @pending_user.email, :password => @pending_user.encrypted_password, :first_name => @pending_user.first_name, :last_name => @pending_user.last_name)
      @user.save

    else
      @account = Account.new(:company_name => @pending_user.company_name)
      @user = User.new(:account_id => @account.id, :email => @pending_user.email, :encrypted_password => @pending_user.encrypted_password, :first_name => @pending_user.first_name, :last_name => @pending_user.last_name)
      @account.save
      @user.save

    end


    # p @user
    # p "*"*80


    render json: @user

  end

  private

  def blank_company(pending_user)
    if params[:pending_user][:company_name] == "" || params[:pending_user][:company_name] == nil
      pending_user.company_name = params[:pending_user][:email]
    end
  end

  def allowed_params
    params.require(:pending_user).permit(:first_name, :last_name, :company_name, :email, :encrypted_password)
  end

  def password_matching_error?(pending_user)
    pending_user.errors[:base] = "Passwords must match" unless passwords_match?
  end

  def passwords_match?
    params[:pending_user][:encrypted_password] == params[:pending_user][:confirm_password]
  end

  def render_error_messages(pending_user)
    password_matching_error?(pending_user)
    pending_user.errors.full_messages.each.with_index(1) do |message, index|
      flash.now["error #{index}"] = message
    end
  end

end