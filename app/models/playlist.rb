class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users
  belongs_to :account

  # this field can be calculated on the fly
  attr_accessor :percent_complete
  attr_accessor :subscribed

  def calc_percent_complete
    # TODO make it right
    self.percent_complete = 33.0
  end

  # figure out if this playlist is sibscibed by a given user
  def calc_subscribed(user_id)
    self.subscribed = false
    if self.users
      for u in self.users
        if u.id == user_id 
          self.subscribed = true
          break
        end
      end
    end
  end

  def self.all_for_company(company_id)
    self.where("account_id=?", company_id)
  end

end
