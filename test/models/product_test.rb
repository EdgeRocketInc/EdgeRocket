require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "Read record" do
  	p = Product.first
    assert p.name.length > 1, 'name length'
  end

  test "Sync rating" do
  	r = Product.sync_rating(1)
  	assert r != nil, 'synced'
  end

  test "Count search items" do
  	c = Product.count_courses(101, nil, nil, nil)
  	assert  !c.nil?, "not nil"
  	assert c.rows[0][0].to_i > 0, "count > 0"
  end

  test "search with criteria" do
  	c = Product.search_courses(101, 10, 0, nil, "data", nil)
  	assert c.rows.length == 10, '10 rows'
  end

  test "search with media and offset" do
  	c = Product.search_courses(101, 10, 1, "video,online,books", nil, nil)
  	assert c.rows.length == 3, '3 rows'
  end

  test "search without account id" do
  	c = Product.search_courses(nil, 10, 0, "video,online,books", nil, nil)
  	assert !c.nil?, "not nil"
  end

end
