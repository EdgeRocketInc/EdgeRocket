class MyCoursesController < ApplicationController
  def index
    @my_courses = Product.all
  end
end
