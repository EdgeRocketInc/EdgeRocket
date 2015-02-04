if @product.nil?
	json.product {}
else
	json.product @product
end