class PendingUser < ActiveRecord::Base
  before_create :encrypt_password



  private

  def encrypt_password
    self.encrypted_password = Devise.bcrypt(User, encrypted_password)
  end

end