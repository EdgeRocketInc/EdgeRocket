class Skill < ActiveRecord::Base
  has_many :recommendations
  has_many :products, through: :recommendations
end
