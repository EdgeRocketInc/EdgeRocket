class PendingUser < ActiveRecord::Base
  before_save :encrypt_password

  validates_presence_of(:first_name, :last_name)
  validates_uniqueness_of :email
  validate :validate_password

  private

  def encrypt_password
    self.encrypted_password = Devise.bcrypt(User, encrypted_password)
  end

  def validate_password
    @user = User.new(email: email, password: encrypted_password)
    @user.valid?
    @user.errors.each do |column, error|
      self.errors.add(column, error)
    end
  end

end