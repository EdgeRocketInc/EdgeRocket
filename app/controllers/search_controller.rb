class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  # GET
  def index

    publish_keen_io(:html, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name,
        :request_format => request.format.symbol
      }
    )

    prd = Product.search_courses(current_user.account_id)

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
