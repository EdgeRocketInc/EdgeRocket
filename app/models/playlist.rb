class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users
  belongs_to :account

  def percent_complete
    # TODO do we need to sanitize SQL here?
    sql = "select avg(mc.percent_complete) percent_avg from playlists_products pp inner join my_courses mc on pp.product_id=mc.product_id where playlist_id=" + id.to_s
    pc = ActiveRecord::Base.connection.execute(sql)
    pc[0]['percent_avg']
  end

  # figure out if this playlist is sibscibed by a given user
  def subscribed?(user_id)
    subscribed = false
    if self.users
      for u in self.users
        if u.id == user_id
          subscribed = true
          break
        end
      end
    end
    subscribed
  end

  def self.all_for_company(company_id)
    self.where("account_id=?", company_id)
  end

end
