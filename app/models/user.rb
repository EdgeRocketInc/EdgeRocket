class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :roles

  def role
    # TODO make it right
    if email.start_with?('superadmin') 
	:superadmin
    elsif email.start_with?('admin') 
	:admin
    else
	:user
    end
  end

end
