require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    sign_in User.find(103)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should create product json" do
    assert_difference('Product.count') do
      post :create, product: { name: @product.name }, :format => 'json'
    end
  end

  test "should create product with playlists" do
    assert_difference('Product.count') do
      post :create, product: { name: 'course abc', playlist_items: [ {playlist_id: 1001} ] }, :format => 'json'
    end
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get product reviews in json" do
    get :reviews, id: @product, :format => 'json'
    assert_response :success
  end

  test "should update product json" do
    patch :update, id: @product, product: { name: @product.name }, \
      playlist_items: [ {playlist_id: 1001} ], :format => 'json'
    assert_response :success
  end

  test "should not destroy product with dependency" do
    assert_difference('Product.count', 0) do
      delete :destroy, id: @product, :format => 'json'
    end

    assert_response 422
  end

  test "should destroy product without dependencies" do
    @product = Product.find(3021) # no dependencies
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product, :format => 'json'
    end

    assert_response :success
  end

end
