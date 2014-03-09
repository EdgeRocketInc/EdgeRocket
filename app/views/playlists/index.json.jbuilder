json.array!(@playlists) do |playlist|
  json.extract! playlist, :id, :title, :mandatory
  json.url playlist_url(playlist, format: :json)
end
