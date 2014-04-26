class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  # GET
  def index

    #TODO make it async
    if !Rails.env.test? && request.format.symbol == :html
      Keen.publish(:ui_actions, { 
        :user_email => current_user.email, 
        :action => controller_path, 
        :method => action_name, 
        :request_format => request.format.symbol 
      })
    end

    prd = Product.search_courses(nil)

    # format some of the fields in the resultset
    prd.each { |p|
      # produce an asset path for Angular to understand and save it in the same array
      p['logo_asset_url'] = view_context.image_path(p['logo_file_name'])
      p['price_fmt'] = p['price'].blank? ? 'Free' : view_context.number_to_currency(p['price'])
    }

    respond_to do |format|
      format.html 
      format.json { 
        render json: prd.as_json 
      }
    end

  end
end
