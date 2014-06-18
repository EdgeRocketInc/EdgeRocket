require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "Read record" do
  	p = Product.first
    assert p.name.length > 1, 'name length'
  end

  test "Sync rating" do
  	r = Product.sync_rating(1)
  	assert r == nil, 'testing the CI errors'
  end

end
