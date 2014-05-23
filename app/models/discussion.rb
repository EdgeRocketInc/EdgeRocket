class Discussion < ActiveRecord::Base
  belongs_to :user

  def self.whole_company(user_id)
  	# TODO add conditions
  	self.all
  end
end
