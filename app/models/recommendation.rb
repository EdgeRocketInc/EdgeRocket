class Recommendation < ActiveRecord::Base
  belongs_to :skill
  belongs_to :product

  validates :skill_id, :numericality => { greater_than: 0}

end
