require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "Read record" do
  	p = Product.first
    assert p.name.length > 1, 'name length'
  end
end
