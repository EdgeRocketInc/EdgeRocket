class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/curated
  # HTML template for curated products that belong to this account only
  # JSON see jbuilder
  def curated_index
    authorize! :manage, :all
    @products = Product.where(:account_id => current_user.account_id).includes(:vendor).order(:name)
  end

  # GET /vendors
  def vendors
    @vendors = Vendor.all.order(:name)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product_json = @product.as_json(include: :vendor)
    if !@product_json['vendor'].nil?
      @product_json['vendor']['logo_asset_url'] = view_context.image_path(@product_json['vendor']['logo_file_name'])
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    # if it's manually entered prodcut, we should set the account to current user's company
    if @product.manual_entry == true
      @product.account_id = current_user.account_id
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { 
          @product_json = @product.as_json
          render action: 'show', status: :created, location: @product 
        }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { 
        if @product.errors.empty? 
          head :no_content 
        else
          render json: @product.errors, status: :unprocessable_entity 
        end
      }
    end
  end

  # GET
  # producs/1/reviews.json
  def reviews
    reviews = Discussion.product_reviews(current_user.account_id, params[:id])
    @reviews_json = reviews.as_json(:include => :user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :authors, :origin, :price, :price_free, :keywords, :school, :description, :media_type, :duration, :vendor_id)
    end
end
