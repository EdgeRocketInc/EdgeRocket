class Skill < ActiveRecord::Base
  has_many :recommendations
end
