json.array!(@posts) do |post|
  json.extract! post, :id, :title, :author, :post_date
  json.url post_url(post, format: :json)
end
