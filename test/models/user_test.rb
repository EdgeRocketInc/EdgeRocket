require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
end
