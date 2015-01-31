json.array!(@vendors) do |vendor|
  json.extract! vendor, :id, :name, :prod_count
end
