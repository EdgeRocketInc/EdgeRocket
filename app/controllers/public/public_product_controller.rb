class Public::PublicProductController < ApplicationController

	layout "public"

	def show
		@product_id = params[:id]
	end

	def show_json
		product = Product.find_by_id(params[:id])
	    @product = product.as_json(include: :vendor)
	    if !@product['vendor'].nil?
	      @product['vendor']['logo_asset_url'] = view_context.image_path(@product['vendor']['logo_file_name'])
	    end
	end

end
