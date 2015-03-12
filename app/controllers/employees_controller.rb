class EmployeesController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    u = current_user
    account = u.account
    users = account ? account.users.order('email') : nil
    @users_json = users.as_json(methods: :best_role)
  end

  # POST /users.json
  # Creates a new user record and adds a user role if provided
  def create

    # get a user role parameter and put it aside to use later
    user_role = params[:employee].nil? ? nil : params[:employee][:best_role]
    params[:employee].delete(:user_role)

    @user = User.new(user_params)
    @user.account_id = current_user.account_id
    if @user.save
      # we can add a role if it's not a regular user
      Role.insert_role(user_role, @user.id)
      Notifications.admin_adds_user_email(@user, request.protocol + request.host_with_port).deliver
    end

    publish_keen_io(:json, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name
    })

    respond_to do |format|
      if @user.errors.empty?
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1.json
  # Update user record and roles
  def update

    # If password is blank it means don't update it
    if params[:password].blank?
      params[:employee].delete(:password)
    end

    # get a user role parameter and put it aside to use later
    user_role = params[:employee].nil? ? nil : params[:employee][:best_role]
    params[:employee].delete(:user_role)

    if @user.update(user_params)
      # we can remove and then add roles now
      Role.where("user_id=?", @user.id).destroy_all
      Role.insert_role(user_role, @user.id)
    end

    respond_to do |format|
      if @user.errors.empty?
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1/password.json
  # changes password and set reset_required to false
  def change_password

    u = User.find(params[:id])
    # TODO confirm that 2 passwords match (server side needs it too)
    if u.valid_password?(params[:current_password])
      u.password = params[:new_password]
      u.reset_required = false
      u.save
      if u.errors.empty?
        sign_in(u, :bypass => true)
      end
    else
      u.errors[:base] << 'Wrong current password'
    end

    publish_keen_io(:json, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name
    })

    respond_to do |format|
      if u.errors.empty?
        format.json { head :no_content }
      else
        format.json { render json: u.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # PATCH /empployees/1/field.json
  # JSON only
  def update_field
    u = User.find(params[:id])
    # TODO make it generic, get the field and value from the params
    u.update(new_courses: false, ui_message_id: nil)

    respond_to do |format|
      if u.errors.empty?
        format.json { head :no_content }
      else
        format.json { render json: u.errors, status: :unprocessable_entity }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # TODO: figure out how to pass and recieve :user instead of :employee
      params.require(:employee).permit(:id, :email, :first_name, :last_name, :password, :reset_required, :user_role, :is_active)
    end

end