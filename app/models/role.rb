class Role < ActiveRecord::Base
  belongs_to :user

  def self.insert_role(user_role, user_id)
	  if !user_role.blank? && user_role != 'user'
	    role = self.new 
	    role.name = user_role
	    role.user_id = user_id
	    role.save
	  end
  end

end
