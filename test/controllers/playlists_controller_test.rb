require 'test_helper'

class PlaylistsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @playlist = playlists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    # TODO probably don't need HTML flavor here at all
    #assert_not_nil assigns(:playlists)
  end


  test "should create playlist" do
    assert_difference('Playlist.count') do
      post :create, playlist: { mandatory: @playlist.mandatory, title: @playlist.title, description: @playlist.description }
    end

    assert_redirected_to playlist_path(assigns(:playlist))
  end

  test "should update playlist" do
    patch :update, id: @playlist, playlist: { mandatory: @playlist.mandatory, title: @playlist.title, description: @playlist.description }
    assert_redirected_to playlist_path(assigns(:playlist))
  end

  test "should destroy playlist" do
    assert_difference('Playlist.count', -1) do
      delete :destroy, id: @playlist
    end

    assert_redirected_to playlists_path
  end
end
