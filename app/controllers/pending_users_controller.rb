class PendingUsersController < ApplicationController

  layout "sign_up"

  def new
    @pending_user = PendingUser.new
  end

  def create
    @pending_user = PendingUser.new(allowed_params)
    if password_match && @pending_user.save
      flash[:notice] = "Thank you for your interest. We will contact you shortly."
      redirect_to root_path
    else
      render :new
    end

  end

  private

  def allowed_params
    params.require(:pending_user).permit(:first_name, :last_name, :company_name, :email, :encrypted_password)
  end

  def password_match
    params[:pending_user][:encrypted_password] == params[:pending_user][:confirm_password]
  end

end