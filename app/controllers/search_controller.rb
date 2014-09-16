class SearchController < ApplicationController
  before_filter :authenticate_user!

  include CleanPagination

  PAGE_SIZE = 50 # should be in sync with UI

  # GET
  def index

    publish_keen_io(:html, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name
    })

    if :json == request.format.symbol
      #byebug
      prd = nil
      # The first query counts items, which is not the best solution, but it's ok for now
      count_result = Product.count_courses(current_user.account_id, params[:inmedia], params[:criteria])
      prd_count = count_result.nil? ? 0 : count_result.rows[0][0].to_i
      paginate prd_count, PAGE_SIZE  do |limit, offset|
        prd = Product.search_courses(current_user.account_id, limit, offset, params[:inmedia], params[:criteria])
      end

      # format some of the fields in the resultset
      if !prd.nil? 
        prd.each { |p|
          # produce an asset path for Angular to understand and save it in the same array
          p['logo_asset_url'] = view_context.image_path(p['logo_file_name'])
        }
      end

    end

    respond_to do |format|
      format.html 
      format.json { 
        render json: prd.as_json
      }
    end

  end
end
