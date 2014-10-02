class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_many :roles
  has_many :my_courses
  has_and_belongs_to_many :playlists
  has_one :budget
  belongs_to :account
  has_many :discussions
  has_one :profile
  has_one :survey, dependent: :destroy

  # returns the role with the highest level of access
  def best_role
    # array of roles in priority order
    role_priorities = [
      { name: 'Sysop', role: :sysop, priority: 0 },
      { name: 'SA', role: :SA, priority: 1 },
      { name: 'Admin', role: :admin, priority: 2 },
      { name: nil, role: :user, priority: 3 }
    ]
    # default role with the lowest priority
    current_role = role_priorities[3]
    # figure out the best role
    roles.each { |ur|
      role_priorities.each { |rp|
        if rp[:name] == ur.name && rp[:priority] < current_role[:priority]
          current_role = rp
        end
      }
    }
    current_role[:role]
  end

  def valid_for_authentication?


    super and self.is_active?

  end



  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        # check if there is a company account for this user's domain
        # if account doesn't exist, then return nil because the user should not be authorized to log in
        domain = data['email']
        if !domain.blank?
          domain = domain.split('@')[1]
          account = Account.where(:domain => domain).first
          if account
            user = User.create(
              provider:access_token.provider,
              email: data["email"],
              uid: access_token.uid ,
              password: Devise.friendly_token[0,20],
              account_id: account.id
            )
          end
        end
      end
    end
  end

end
