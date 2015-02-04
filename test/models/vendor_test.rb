require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  test "Read record" do
  	v = Vendor.first
    assert v.name.length > 1, 'name length'
  end
end
