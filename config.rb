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

  # Normalize tags for an entry from merged_blog_posts (article or external post). Returns array of strings.
  def entry_tags(entry)
    if entry[:local] && entry[:article]
      a = entry[:article]
      t = a.data[:tags]
      return [] if t.nil?
      return t if t.is_a?(Array)
      return t.to_s.split(/\s*,\s*/).map(&:strip).reject(&:empty?) if t.respond_to?(:to_s)
      []
    end
    post = entry[:post]
    return [] unless post
    list = post[:tag_list] || post["tag_list"]
    return list if list.is_a?(Array) && list.any?
    tags_arr = post[:tags] || post["tags"]
    return tags_arr if tags_arr.is_a?(Array) && tags_arr.any?
    raw = tags_arr.to_s
    return [] if raw.empty?
    raw.split(/\s*,\s*/).map(&:strip).reject(&:empty?)
  end

  # All unique tags across merged blog posts, sorted.
  def all_blog_tags
    merged_blog_posts.flat_map { |e| entry_tags(e) }.uniq.sort
  end

  # Unique years from merged blog posts, descending.
  def all_blog_years
    merged_blog_posts.map { |e| e[:date].respond_to?(:year) ? e[:date].year : e[:date].to_time.year }.uniq.sort.reverse
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
