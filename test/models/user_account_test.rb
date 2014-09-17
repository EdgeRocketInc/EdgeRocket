require 'test_helper'

class UserAccountTest < ActiveSupport::TestCase
  test "turning pending user into user" do
    pending_user = PendingUser.new(first_name:"Jimi", last_name: "Hendrix", company_name: "EdgeRocket", email: "jimihendrix@edgerocket.co", encrypted_password: "password", user_type: "Free")
    u = UserAccount.new(pending_user,'http://localhost')
    u.save_user
    assert User.last.last_name == pending_user.last_name
  end
end
