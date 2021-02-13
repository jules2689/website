activate :directory_indexes
activate :asset_hash
set :relative_links, true

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Webpack
activate :external_pipeline,
 name: :webpack,
 command: build? ?
   "npm run build" :
   "npm run start",
 source: ".tmp/dist",
 latency: 1
 
configure :development do
  set :css_dir, ".tmp/dist"
  set :js_dir, ".tmp/dist"
end

configure :production do
  set :css_dir, "build"
  set :js_dir, "build"
end
