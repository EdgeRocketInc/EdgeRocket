class Role < ActiveRecord::Base
  belongs_to :user

  # Map of all possible role names
  ROLES = { 
  	'admin' => 'Admin',
  	'sa' => 'SA',
  	'sysop' => 'Sysop'
  }

  # insert a role only if it's in the map of defined roles
  def self.insert_role(user_role, user_id)
	  if !user_role.blank? && user_role != 'user'
	    role = self.new 
	    role.name = ROLES[user_role.downcase]
	    if !role.name.blank?
	    	role.user_id = user_id
	    	role.save
	    end
	  end
  end

end
