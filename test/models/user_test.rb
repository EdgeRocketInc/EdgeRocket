require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user roles" do
    u = User.find(101)
    assert u.roles.length > 0
  end
end
