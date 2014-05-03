class MyCourses < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  scope :with_products, lambda { includes(:product) }

  # TODO this is ugly, need to change to scopes/etc

  def self.all_completed(user_id)
    self.all_with_status(user_id, 'compl')
  end

  def self.all_wip(user_id)
    self.all_with_status(user_id, 'wip')
  end

  def self.all_registered(user_id)
    self.all_with_status(user_id, 'reg')
  end

  def self.all_wishlist(user_id)
    self.all_with_status(user_id, 'wish')
  end

  def self.all_with_status(user_id, status)
    where("user_id = ? and status = ?", user_id, status)
  end

  def self.find_courses(user_id, product_id)
    where("user_id = ? and product_id = ?", user_id, product_id)
  end

end
