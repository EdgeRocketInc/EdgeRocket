class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.where(skill_id: params["skill_id"]) if params["skill_id"]
    @skills = Skill.all
    @products = Product.all
  end

  def destroy
    recommendation = Recommendation.find(params[:id])
    recommendation.destroy
    redirect_to :back
  end

end
