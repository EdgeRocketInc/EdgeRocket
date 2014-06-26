json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :origin, :price, :price_free, :keywords, :school, :media_type, :duration, :authors
  json.vendor product.vendor
  json.url product_url(product, format: :json)
end
