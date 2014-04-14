class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  # GET
  def index
    prd = Product.search_courses(nil)

    respond_to do |format|
      format.html 
      format.json { 
        render json: prd.as_json 
      }
    end

  end
end
