require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  test "Read record" do
  	pl = Playlist.first
    assert pl.title.length > 1, 'title length'
  end
end
