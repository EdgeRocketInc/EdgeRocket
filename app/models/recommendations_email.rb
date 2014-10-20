class RecommendationsEmail < ActiveRecord::Base
  has_and_belongs_to_many :user
  belongs_to :survey

  def self.save_recommendations_email(user, skills, survey_id)
    recommendations_hash = {}
    skills.each do |skill|
      skill_from_db = Skill.find(skill)
      if skill_from_db.present?
        products = skill_from_db.recommendations.map do |recommendation|
          recommendation.product_id
        end
        recommendations_hash[skill] = products
      end
    end

    RecommendationsEmail.create!(user_id: user.id, recommendation: recommendations_hash.to_json, survey_id: survey_id)
  end

  def recommendations
    recommendation_hash = JSON.parse(recommendation)

    recommendation_hash.map do |skill_id, product_id|
      {skill: Skill.find(skill_id), recommendations: Product.find(product_id)}
    end
  end
  
end