class Recommendation < ActiveRecord::Base
  belongs_to :skill
  belongs_to :product
end
