class Discussion < ActiveRecord::Base
  belongs_to :user

  # returns discussions for all users in the same company
  def self.whole_company(account_id)
  	# TODO: shoudl we add flexibale limit/pagination?
  	self.joins(:user).where("account_id=?", account_id).order('updated_at DESC').limit(10)
  end
end
