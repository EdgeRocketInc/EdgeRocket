class SearchController < ApplicationController
  before_filter :authenticate_user!

  include CleanPagination

  PAGE_SIZE = 100

  # GET
  def index

    publish_keen_io(:html, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name
    })

    if :json == request.format.symbol
      prd = nil
      # TODO use correct count, because Product.count may be off
      prd_count = Product.count
      # TODO use PAGE_SIZE as the second paramater
      paginate prd_count, prd_count  do |limit, offset|
        prd = Product.search_courses(current_user.account_id, limit, offset)
      end

      # format some of the fields in the resultset
      prd.each { |p|
        # produce an asset path for Angular to understand and save it in the same array
        p['logo_asset_url'] = view_context.image_path(p['logo_file_name'])
      }

    end

    respond_to do |format|
      format.html 
      format.json { 
        render json: prd.as_json
      }
    end

  end
end
