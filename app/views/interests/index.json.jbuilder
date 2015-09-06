json.array!(@interests) do |interest|
  json.extract! interest, :id, :interest_type, :treatment, :embed_url, :url, :provider, :title
  json.url interest_url(interest, format: :json)
end
