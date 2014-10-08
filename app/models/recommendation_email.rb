class RecommendationEmail < ActiveRecord::Base
  has_and_belongs_to_many :user
  has_and_belongs_to_many :skill
  has_and_belongs_to_many :product
end