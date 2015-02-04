class Survey < ActiveRecord::Base
  validates_presence_of :preferences, :user_id
  belongs_to :user
  has_one :recommendations_email
end