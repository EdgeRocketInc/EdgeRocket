require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test "Read record" do
  	pl = Playlist.first
    assert pl.title.length > 1, 'title length'
  end

  test "Add product to playlist" do
  	pl = Playlist.first
  	l1 = pl.products.length
  	product = pl.products.build
  	product.name = 'Product in Playlist'
  	product.save
  	assert pl.products.length > l1, 'more linked products'
  end

  test "calculate internal fields" do
    pl = Playlist.first
    pl.calc_percent_complete
    assert pl.percent_complete.to_i > 0, 'wrong calculation'
  end

  test "calculate subscriptions" do
    pl1 = Playlist.find(2001)
    assert pl1.subscribed?(101) == false, 'wrong subscription 1'
    assert pl1.subscribed?(102) == true, 'wrong subscription 2'

    pl2 = Playlist.find(1001)
    assert pl2.subscribed?(101) == true, 'wrong subscription 3'
 end

end
