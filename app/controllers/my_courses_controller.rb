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
  end
end
