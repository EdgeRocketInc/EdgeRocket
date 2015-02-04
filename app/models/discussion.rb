class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  # returns discussions for all users in the same company
  def self.whole_company(account_id)
  	# TODO: shoudl we add flexibale limit/pagination?
  	self.joins(:user).where("account_id=?", account_id).order('updated_at DESC').limit(10)
  end

  # returns discussions for this product and only within this company
  def self.product_reviews(account_id, product_id)
  	# TODO: shoudl we add flexibale limit/pagination?
  	self.joins(:user).where("account_id=? and product_id=?", account_id, product_id).order('updated_at DESC').limit(10)
  end
  
end
