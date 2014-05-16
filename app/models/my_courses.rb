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

  # set the percent complete member varibale value depending on the status
  def self.calc_percent_complete(status)
    pcomplete = 0

    case status
    when 'compl'
      pcomplete = 100
    when 'wip'
      pcomplete = 50
    end

    return pcomplete
  end

  def self.subscribe(user_id, prd_id, status, assigned_by)
    my_crs = MyCourses.find_courses(user_id, prd_id)
    # TODO handle exceptions
    if my_crs.nil? || my_crs.length == 0
      my_crs = MyCourses.new()
      my_crs.user_id = user_id
      my_crs.product_id = prd_id
      my_crs.status = status #params[:status]
      my_crs.assigned_by = assigned_by #params[:assigned_by]
      my_crs.percent_complete = MyCourses.calc_percent_complete(my_crs.status)
      my_crs.save
    end
  end

  def self.unsubscribe(user_id, prd_id)
    # TODO what do we do if a course is in the progress? Also, need to handle exceptions
    MyCourses.where(:user_id => user_id, :product_id => prd_id).destroy_all
  end

end
