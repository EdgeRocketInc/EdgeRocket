class MyCoursesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @course_groups = Hash.new  
    u = User.find_by_email(current_user.email)

    # --- Courses section
    # TODO this can be more DRY and pushed to the view
    my_courses = MyCourses.all_completed(u.id)
    if my_courses && my_courses.length > 0
      @course_groups['Completed'] = my_courses
    end

    my_courses = MyCourses.all_wip(u.id)
    if my_courses && my_courses.length > 0
      @course_groups['In Progress'] = my_courses
    end

    my_courses = MyCourses.all_registered(u.id)
    if my_courses && my_courses.length > 0
      @course_groups['Registered'] = my_courses
    end

    my_courses = MyCourses.all_wishlist(u.id)
    if my_courses && my_courses.length > 0
      @course_groups['Wishlist'] = my_courses
    end

    # --- Playlists section
    @my_playlists = u.playlists
    @my_playlists.each { |pl|
      pl.calc_percent_complete
    }

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

  # DELETE :id
  # unsubscribe currently authenitcated user from the course
  # JSON: empty
  def unsubscribe
    # TODO implement
  end
    
end
