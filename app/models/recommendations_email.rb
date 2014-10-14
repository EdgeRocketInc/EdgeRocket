class RecommendationsEmail < ActiveRecord::Base
  has_and_belongs_to_many :user
  belongs_to :survey


  def self.save_recommendations_email(user, skills, survey_id)

    recommendations_hash = {}
    skills.each do |skill|
      products = Skill.find(skill).recommendations.map do |recommendation|
        recommendation.product_id
      end
      recommendations_hash[skill] = products
    end

    RecommendationsEmail.create!(user_id: user.id, recommendation: recommendations_hash.to_json, survey_id: survey_id)

  end
end