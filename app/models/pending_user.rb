class PendingUser < ActiveRecord::Base
  before_save :encrypt_password

  validates_presence_of(:first_name, :last_name)
  validates_uniqueness_of :email
  validate :email_in_use, :validate_password

  private

  def encrypt_password
    self.encrypted_password = Devise.bcrypt(User, encrypted_password)
  end

  def email_in_use
    @user ||= User.find_by(email: email)
    errors.add(:base, 'Email has already been taken') if @user
  end

  def validate_password
    @user = User.new(email: email, password: encrypted_password)
    @user.valid?
    @user.errors.full_messages.each do |error|
      self.errors[:base].push error
    end
  end

end