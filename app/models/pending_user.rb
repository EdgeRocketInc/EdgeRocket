class PendingUser < ActiveRecord::Base
  before_save :encrypt_password

  validates_presence_of(:email, :encrypted_password, :first_name, :last_name)

  private

  def encrypt_password
    self.encrypted_password = Devise.bcrypt(User, encrypted_password)
  end

end