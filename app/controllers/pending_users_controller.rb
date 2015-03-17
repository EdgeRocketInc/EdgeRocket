class PendingUsersController < ApplicationController

  layout "sign_up"

  def new
    @pending_user = PendingUser.new
  end

  # IMPORTANT: Short-cucruiting user creation to streamline the process
  def create

    if params[:pending_user][:user_type] == "member" || params[:pending_user][:user_type] == "enterprise" || params[:pending_user][:user_type] == "team"
      @account_type = params[:pending_user][:user_type]
    elsif params[:pending_user][:user_type] == "common"
      @account_type = "common"
      redirect_param = "common"
    else
      @account_type = "free"
    end
    @pending_user = PendingUser.new(allowed_params.merge(:user_type => @account_type))
    blank_company(@pending_user)
    # Autogenerate the password and send it to the user
    generated_password = Devise.friendly_token.first(8)
    @pending_user.encrypted_password = generated_password
    if @pending_user.save

      # Notify Sysops that user is being created 
      # The Welcome notification to the user is sent after user is created
      Notifications.account_request_received(@pending_user, request.protocol + request.host_with_port).deliver

      user = UserAccount.new(@pending_user, request.protocol + request.host_with_port)
      user.save_user(generated_password)
      
      flash[:notice] = "Thank you for signing up, please check your email and log in."

      #byebug
      redirect_to app_path({:type => redirect_param})
    else
      render_error_messages(@pending_user)
      render :new
    end

  end

  def create_user_from_pending
    @pending_user = PendingUser.find_by(id: params["id"])
    user = UserAccount.new(@pending_user, request.protocol + request.host_with_port)
    user.save_user(nil)

    render json: user
  end

  private

  def blank_company(pending_user)
    if params[:pending_user][:company_name].blank?
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