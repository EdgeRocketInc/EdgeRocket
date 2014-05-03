class MyCoursesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @course_groups = Array.new
    u = User.find_by_email(current_user.email)

    # --- Courses section
    # TODO this can be more DRY and pushed to the view
    my_courses = MyCourses.all_completed(u.id)
    @course_groups << {
      :status => 'compl',
      :my_courses => my_courses.as_json(:include => :product)
    }

    my_courses = MyCourses.all_wip(u.id)
    @course_groups << {
      :status => 'wip',
      :my_courses => my_courses.as_json(:include => :product)
    }

    my_courses = MyCourses.all_registered(u.id)
    @course_groups << {
      :status => 'reg',
      :my_courses => my_courses.as_json(:include => :product)
    }

    my_courses = MyCourses.all_wishlist(u.id)
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
    if @account && @account.budget_management == true
     @budget = u.budget
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
    u = User.find_by_email(current_user.email)
    prd_id = params[:course_id]
    my_crs = MyCourses.find_courses(u.id, prd_id)
    # TODO handle exceptions
    if my_crs.nil? || my_crs.length == 0
      my_crs = MyCourses.new()
      my_crs.user_id = u.id
      my_crs.product_id = prd_id
      my_crs.status = params[:status]
      my_crs.save
    end
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
    MyCourses.update(mc_id, :status => params[:status])
    result = { 'id' => mc_id }

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

end
