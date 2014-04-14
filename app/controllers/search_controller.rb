class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  # GET
  def index
    prd = Product.search_courses(nil)

    # TODO
    #prd.each { |p|
    #  p['logo_asset_url'] = image_path(p['logo_file_name'])
    #}

    respond_to do |format|
      format.html 
      format.json { 
        render json: prd.as_json 
      }
    end

  end
end
