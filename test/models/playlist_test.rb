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
end
