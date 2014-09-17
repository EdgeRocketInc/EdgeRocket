class UserAccount
  def initialize(pending_user)
    @pending_user = pending_user
  end

  def save_user
    account_exists = Account.find_by(:company_name => @pending_user.company_name)
    if account_exists

      @user = User.new(:account_id => account_exists.id, :email => @pending_user.email, :password => @pending_user.encrypted_password, :first_name => @pending_user.first_name, :last_name => @pending_user.last_name)
    else
      @account = Account.new(:company_name => @pending_user.company_name)
      @user = User.new(:account_id => @account.id, :email => @pending_user.email, :password => @pending_user.encrypted_password, :first_name => @pending_user.first_name, :last_name => @pending_user.last_name)
      @account.save
    end

    @user.encrypted_password = @pending_user.encrypted_password
    @user.save
    @role = Role.new(name:'Admin', user_id: @user.id)
    @role.save
    @pending_user.destroy
  end

end