class PendingUsersController < ApplicationController

  layout "sign_up"

  def new
    @pending_user = PendingUser.new
  end

  def create
    @pending_user = PendingUser.new(allowed_params)
    if passwords_match? && @pending_user.save
      flash[:notice] = "Thank you for your interest. We will contact you shortly."
      redirect_to root_path
    else
      render_error_messages(@pending_user)
      render :new
    end

  end

  private

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