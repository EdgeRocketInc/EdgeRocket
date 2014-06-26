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

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { name: @product.name }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get product reviews in json" do
    get :reviews, id: @product, :format => 'json'
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { name: @product.name }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should not destroy product with dependency" do
    assert_difference('Product.count', 0) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end

  test "should destroy product without dependencies" do
    @product = Product.find(3021) # no dependencies
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end

end
