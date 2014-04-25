class MyCourses < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  def self.all_completed(user_id)
    self.all_with_status(user_id, 'Completed')
  end

  def self.all_wip(user_id)
    self.all_with_status(user_id, 'WIP')
  end

  def self.all_registered(user_id)
    self.all_with_status(user_id, 'Registered')
  end

  def self.all_wishlist(user_id)
    self.all_with_status(user_id, 'Wishlist')
  end

  def self.all_with_status(user_id, status)
    where("user_id = ? and status = ?", user_id, status)
  end

  def self.find_courses(user_id, product_id)
    where("user_id = ? and product_id = ?", user_id, product_id)
  end

end
