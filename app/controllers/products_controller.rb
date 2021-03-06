class ProductsController < ApplicationController

  include PlaylistsOperations

  before_action :set_product, only: [:show, :show_html, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /products.json
  def index
    publish_keen_io(:json, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name
    })
    @products = Product.all.order(:name)
  end

  # GET /products/curated
  # HTML template for curated products that belong to this account only
  # JSON see jbuilder
  def curated_index
    authorize! :manage, :all
    @products = nil
    # Find all non global products for sysop, but only account specific ones for other roles
    if current_user.best_role == :sysop
      @products = Product.where("account_id is not null or manual_entry=?", true).includes(:vendor, :playlist_items, :account).order(:name)
    else
      @products = Product.where(:account_id => current_user.account_id).includes(:vendor, :playlist_items, :account).order(:name)
    end
  end

  # GET /vendors
  def vendors
    @vendors = Vendor.all_count_by_product()
  end

  # GET /products/1
  # .html
  def show_html
    publish_keen_io(:html, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name,
        :product_id => @product.id
    })
  end

  # GET /products/1.json
  def show
    publish_keen_io(:json, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name,
        :product_id => @product.id
    })

    @product_json = @product.as_json(include: :vendor)
    if !@product_json['vendor'].nil?
      @product_json['vendor']['logo_asset_url'] = view_context.image_path(@product_json['vendor']['logo_file_name'])
    end
  end

  # POST /products.json
  # JSON only
  #
  # Create a new product item and add it to the playlist if needed
  #
  def create
    @product = Product.new(product_params)
    @product.save

    if @product.errors.empty?
      # if an array of playlists was supplied in the request, then add the newly
      # created product to the provided playslists
      playlists = params[:playlist_items]
      if !playlists.nil?
        playlists.each { |pl|
          # find the playlist to get an object with its relationships
          pl_record = Playlist.find(pl[:playlist_id])
          if !pl_record.nil?
            add_course_to_playlist(pl_record, @product, current_user)
          end
        }
      end
    end

    respond_to do |format|
      if @product.errors.empty?
        format.json { 
          @product_json = @product.as_json
          render action: 'show', status: :created, location: @product 
        }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1.json
  def update

    @product.update(product_params)

    if @product.errors.empty?
      # if an array of playlists was supplied in the request, then add, delete, or keep the 
      # updated product to the provided playslists
      existing_playlists = @product.playlist_items
      playlists = params[:playlist_items]
      # first add new playlists
      if !playlists.nil?
        playlists.each { |pl|
          existing_index = existing_playlists.index { |epl| epl.playlist_id==pl[:playlist_id] }
          if existing_index.nil?
            # find the playlist to get an object with its relationships
            pl_record = Playlist.find(pl[:playlist_id])
            if !pl_record.nil?
              add_course_to_playlist(pl_record, @product, current_user)
            end
          end
        }
      end
      # second, delete playlists that are not requested anymore
      if !existing_playlists.nil?
        existing_playlists.each { |pl|
          new_index = nil
          if !playlists.nil?
            new_index = playlists.index { |epl| epl[:playlist_id]==pl[:playlist_id] }
          end
          if new_index.nil?
            PlaylistItem.where("playlist_id=? and product_id=?", pl.playlist_id, @product.id).destroy_all
          end
        }
      end
    end

    respond_to do |format|
      if @product.errors.empty?
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
    #debugger
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

  # POST /products/1/goto.json
  # JSON only
  #
  # Post a product click event to KeenIO
  #
  def post_goto

    publish_keen_io(:json, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name,
        :product_id => params[:id]
    })

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :authors, :origin, :price, :price_free, :keywords, \
        :school, :description, :media_type, :duration, :vendor_id, :account_id)
    end
end
