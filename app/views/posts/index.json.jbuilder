json.array!(@posts) do |post|
  json.extract! post, :id, :title, :body, :handle
  json.url post_url(post, format: :json)
end
