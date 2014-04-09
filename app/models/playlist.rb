class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users
  belongs_to :account

  # this field can be calculated on the fly
  attr_accessor :percent_complete
  attr_accessor :subscribed

  def calc_fields
    # TODO make it right
    self.percent_complete = 33.0
    self.subscribed = true
  end

  def self.all_for_company(company_id)
    self.where("account_id=?", company_id)
  end

end
