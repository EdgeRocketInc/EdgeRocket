require 'test_helper'


class UserTest < ActiveSupport::TestCase

  class OA
    
    class Info
      def email
      end
    end

    def info
      Info.new
    end

    def provider
    end

    def uid
      #'random$$$%#%#^#'
    end
  end


  test "user role joined" do
    u = User.find(101)
    assert u.roles.length > 0
  end

  test "user role method" do
    u = User.find(101)
    assert u.best_role == :SA, 'expected SA'
    u = User.find(102)
    assert u.best_role == :admin, 'expected admin'
    u = User.find(103)
    assert u.best_role == :user
  end

  test "count incomplete courses" do
    u = User.find(101)
    assert u.count_incomplete_courses() > 0
  end

  test "find google auth" do
    oa = OA.new
    u = User.find_for_google_oauth2(oa)
    assert !u.nil?
  end

  test "find linkedin auth" do
    oa = OA.new
    u = User.find_for_linkedin(oa)
    assert !u.nil?
  end


end
