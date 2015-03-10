class Skill < ActiveRecord::Base
  has_many :recommendations
  has_many :products, through: :recommendations

  # find the closest skill that matches the parameter
  def self.find_a_match(skill_name)
    skill = nil
    if !skill_name.blank?
    	skill = Skill.find_by_key_name(skill_name)
    	if skill.nil?
    		skill = Skill.where("synonyms_json like ?", "%#{skill_name}%").first
    	end
    end
  	return skill
  end
end
