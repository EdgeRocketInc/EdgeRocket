class Public::PublicProductController < ApplicationController

	layout "public"

	def show
		@product_id = params[:id]
	end

	def show_json
		@product = Product.find_by_id(params[:id])
	end

end
