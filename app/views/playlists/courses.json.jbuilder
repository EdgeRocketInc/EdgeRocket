json.array!(@playlist.products) do |prd|
  json.extract! prd, :id, :name
end
