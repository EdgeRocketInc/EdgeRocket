class MyCoursesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @course_groups = Array.new
    u = current_user

    # --- Courses section
    # TODO this can be more DRY and pushed to the view
    my_courses = MyCourse.all_completed(u.id)
    @course_groups << {
      :status => 'compl',
      :my_courses => my_courses.as_json(:include => :product)
    }

    my_courses = MyCourse.all_wip(u.id)
    @course_groups << {
      :status => 'wip',
      :my_courses => my_courses.as_json(:include => :product)
    }

    my_courses = MyCourse.all_registered(u.id)
    @course_groups << {
      :status => 'reg',
      :my_courses => my_courses.as_json(:include => :product)
    }

    my_courses = MyCourse.all_wishlist(u.id)
    @course_groups << {
      :status => 'wish',
      :my_courses => my_courses.as_json(:include => :product)
      }

    vendors = Vendor.all.as_json
    vendors.each { |v|
      v['logo_asset_url'] = view_context.image_path(v['logo_file_name'])
    }

    # --- Playlists section
    @my_playlists = u.playlists

    # --- Budget section
    @account = u.account
    if !@account.blank? && !@account.options.blank? 
      options = ActiveSupport::JSON.decode(@account.options)
      if options['budget_management'] == true
        @budget = u.budget
      end
    end

    #TODO make it async
    if !Rails.env.test? && request.format.symbol == :html
      Keen.publish(:ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name,
        :request_format => request.format.symbol
      })
    end

    respond_to do |format|
      format.html
      format.json {
        # combine all aobject into one JSON result
        json_result = Hash.new()
        json_result['account'] = @account
        json_result['my_playlists'] = @my_playlists.as_json(methods: :percent_complete, include: :products)
        json_result['course_groups'] = @course_groups
        json_result['vendors'] = vendors
        render json: json_result.as_json
      }
    end

  end

  # POST
  # subscribe currently authenitcated user to the course
  # JSON: {"course_id":"1003"}
  def subscribe
    u = current_user
    prd_id = params[:course_id]

    MyCourse.subscribe(u.id, prd_id, params[:status], params[:assigned_by])

    result = { 'user_ud' => u.id, 'course_id' => prd_id }

    respond_to do |format|
        format.json { render json: result.as_json }
    end

  end

  # PUT
  # change the subscribtion status for the given subscription
  # JSON: {"id":"1003"}
  def update_subscribtion
    mc_id = params[:id]

    # when subscription changes, we need to set the date and %complete
    new_status = params[:status]
    pcompl = MyCourse.calc_percent_complete(new_status)
    d = DateTime.now
    MyCourse.update(mc_id, :status => new_status, :percent_complete => pcompl, :completion_date => d)
    result = { 'id' => mc_id, 'percent_complete' => pcompl, 'completion_date' => d }

    respond_to do |format|
        format.json { render json: result.as_json }
    end

  end

  # DELETE :id
  # unsubscribe currently authenitcated user from the course
  # JSON: empty
  def unsubscribe
    # TODO implement
  end


  # GET /my_courses/1.json
  def show
    @my_course = nil
    my_courses = MyCourse.where("product_id=? and user_id=?", params[:product_id], current_user.id)
    if !my_courses.nil? && my_courses.length > 0
      @my_course = my_courses[0]
    end
  end


  # PUT
  # change the rating
  # JSON: {"my_rating":"0.5"}
  def update_rating
    mc_id = params[:id]

    # when subscription changes, we need to set the date and %complete
    new_rating = params[:my_rating]
    MyCourse.update(mc_id, :my_rating => new_rating)

    # also make sure to keep avg rating in sync
    Product.sync_rating(params[:product_id])

    result = { 'id' => mc_id, 'my_rating' => new_rating }

    respond_to do |format|
        format.json { render json: result.as_json }
    end

  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:my_course).permit(:rating)
  end

end
