class MyCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  scope :with_products, lambda { includes(:product) }

  # TODO this is ugly, need to change to scopes/etc

  def self.all_completed(user_id)
    # this is a special case because we want to sort by completion date
    where("user_id = ? and status = ?", user_id, 'compl').order('completion_date')
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
    # we want to sort courses withing each status by their rank
    self.find_by_sql [ \
      'select mc.* from my_courses as mc ' \
      + ' left join ' \
      + ' (select pi.product_id pid, min(rank) r ' \
      + ' from playlists p ' \
      + ' join users u on p.account_id=u.account_id ' \
      + ' join playlist_items pi on p.id=pi.playlist_id ' \
      + ' where u.id = ? and rank is not null ' \
      + ' group by product_id) j on mc.product_id = j.pid ' \
      + ' where mc.user_id = ? and status=? ' \
      + ' order by status, r', user_id, user_id, status]
  
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
    my_crs = MyCourse.find_courses(user_id, prd_id)
    # TODO handle exceptions
    if my_crs.nil? || my_crs.length == 0
      my_crs = MyCourse.new()
      my_crs.user_id = user_id
      my_crs.product_id = prd_id
      my_crs.status = status #params[:status]
      my_crs.assigned_by = assigned_by #params[:assigned_by]
      my_crs.percent_complete = MyCourse.calc_percent_complete(my_crs.status)
      my_crs.save
    end
  end

  def self.unsubscribe(user_id, prd_id)
    # TODO what do we do if a course is in the progress? Also, need to handle exceptions
    MyCourse.where(:user_id => user_id, :product_id => prd_id).destroy_all
  end

  # Count courses per user for the dashboard report
  def self.courses_per_user(account_id)
    # TODO do we need to sanitize SQL here?
    sql = 'select count(cnt) as number_of_users, cnt as number_of_courses ' \
      + ' from (' \
      + ' select count(mc.id) cnt, user_id ' \
      + ' from my_courses mc join users u on mc.user_id=u.id ' \
      + " where status='compl' and u.account_id=" + account_id.to_s \
      + ' group by user_id ) as g ' \
      + ' group by cnt order by 1'

    pc = ActiveRecord::Base.connection.execute(sql)
    pc.as_json
  end

  def completed?
    completion_date.present?
  end

end
