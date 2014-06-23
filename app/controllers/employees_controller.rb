class EmployeesController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    u = current_user
    account = u.account
    @users = account ? account.users.order('email') : nil
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)
    @user.account_id = current_user.account_id

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    # If password is blank it means don't update it
    if params[:password].blank?
      params[:employee].delete(:password)
    end

    respond_to do |format|
      if @user.update(user_params)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # TODO: figure out how to pass and recieve :user instead of :employee
      params.require(:employee).permit(:id, :email, :first_name, :last_name, :password, :reset_required)
    end

end