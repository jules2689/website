activate :directory_indexes
activate :asset_hash
set :relative_links, true

# Blog: markdown posts with front matter; articles in source/blog/
activate :blog do |blog|
  blog.prefix = "blog"
  blog.sources = "{year}-{month}-{day}-{title}.html"
  blog.permalink = "{year}/{month}/{day}/{title}.html"
  blog.layout = "blog_layout"
  blog.summary_length = 140
  blog.summary_separator = /READMORE/
end

# Helpers: merged blog posts (local + data.blog) for use in blog index and home Writing section
helpers do
  def merged_blog_posts
    local = (blog.articles rescue []).map { |a| { date: a.date.to_time, local: true, article: a } }
    external = (data.blog || []).map do |post|
      time = parsed_external_post_date(post)
      { date: time, local: false, post: post }
    end
    (local + external).sort_by { |e| -e[:date].to_i }
  end

  def parsed_external_post_date(post)
    str = post[:published_timestamp] || post["published_timestamp"] || post[:published_at] || post["published_at"]
    return Time.parse(str) if str && !str.to_s.empty?
    str = post[:readable_publish_date] || post["readable_publish_date"].to_s
    return Time.now if str.to_s.empty?
    begin
      Time.parse(str)
    rescue ArgumentError
      Time.now
    end
  end
end

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
