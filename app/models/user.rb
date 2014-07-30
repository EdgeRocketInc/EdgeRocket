class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :roles
  has_many :my_courses
  has_and_belongs_to_many :playlists
  has_one :budget
  belongs_to :account
  has_many :discussions
  has_one :profile 

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

end
