json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :origin, :price, :price_free, :keywords, :school, :media_type, :duration, :authors, :account_id
  json.vendor product.vendor
  json.playlist_items product.playlist_items
  json.account product.account
  json.url product_url(product, format: :json)
end
