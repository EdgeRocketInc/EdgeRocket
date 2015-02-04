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
      post :create, playlist: { mandatory: @playlist.mandatory, title: @playlist.title, description: @playlist.description }, :format => 'json'
    end

    assert_response :success
  end

  test "should update playlist" do
    patch :update, id: @playlist, playlist: { mandatory: @playlist.mandatory, title: @playlist.title, description: @playlist.description }, :format => 'json'
    assert_response :success
  end

  test "should destroy playlist" do
    assert_difference('Playlist.count', -1) do
      delete :destroy, id: @playlist, :format => 'json'
    end

    assert_response :success
  end

  test "should add course to playlist" do
    post :add_course, {id: @playlist, course_id: 2001, :format => 'json'}
    assert_response :success
  end

  test "should remove course from playlist" do
    post :remove_course, {id: @playlist, course_id: 2001, :format => 'json'}
    assert_response :success
  end


end
