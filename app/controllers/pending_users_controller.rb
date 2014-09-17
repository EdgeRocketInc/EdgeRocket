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
    user = UserAccount.new(@pending_user)
    user.save_user

    render json: user
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