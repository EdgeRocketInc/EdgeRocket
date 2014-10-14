class RecommendationsController < ApplicationController

  before_filter :ensure_sysop_user
  layout "system"

  def index
    @skill = Skill.find(params["skill_id"]) if params["skill_id"]
    @selected = params["skill_id"].to_i
    @skills = Skill.all.order('name ASC')
    @products = Product.all.order('name ASC')
  end

  def create

    @recommendation = Recommendation.create!(skill_id: params[:skill_id], product_id: params[:product_id])
    redirect_to :back

  end

  def destroy
    recommendation_find = Recommendation.find(params[:id])
    recommendation = recommendation_find
    recommendation.destroy
    redirect_to :back
  end



end


