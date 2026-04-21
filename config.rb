require 'kramdown-parser-gfm'

activate :directory_indexes
activate :asset_hash
set :relative_links, true

# Fenced code blocks + tables, etc.; client-side highlighting via highlight.js (see assets/javascripts/site.js)
set :markdown,
  input: 'GFM',
  syntax_highlighter: nil,
  hard_wrap: false

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

  # Tag allowlist from data/blog_tags.yaml (single source of truth). Case-insensitive match returns allowlist casing.
  def blog_tag_allowlist
    @blog_tag_allowlist ||= (data.blog_tags&.tags || []).freeze
  end

  def blog_tag_allowlist_lookup
    @blog_tag_allowlist_lookup ||= blog_tag_allowlist.map { |t| [t.to_s.downcase, t] }.to_h.freeze
  end

  def filter_tags_to_allowlist(raw_tags)
    return [] if raw_tags.nil?
    list = raw_tags.is_a?(Array) ? raw_tags : raw_tags.to_s.split(/\s*,\s*/).map(&:strip).reject(&:empty?)
    return list if blog_tag_allowlist.empty?
    list.filter_map { |tag| blog_tag_allowlist_lookup[tag.to_s.downcase] }.uniq
  end

  # Normalize tags for an entry from merged_blog_posts (article or external post). Returns array of strings.
  # Tags are filtered to blog_tag_allowlist when present (case insensitive), using allowlist casing.
  def entry_tags(entry)
    if entry[:local] && entry[:article]
      a = entry[:article]
      t = a.data[:tags]
      return [] if t.nil?
      arr = t.is_a?(Array) ? t : t.to_s.split(/\s*,\s*/).map(&:strip).reject(&:empty?)
      return filter_tags_to_allowlist(arr)
    end
    post = entry[:post]
    return [] unless post
    raw = post[:tags] || post["tags"]
    raw = raw.to_s.split(/\s*,\s*/).map(&:strip).reject(&:empty?) unless raw.is_a?(Array)
    return [] if raw.nil? || (raw.respond_to?(:empty?) && raw.empty?)
    filter_tags_to_allowlist(raw)
  end

  # All unique tags across merged blog posts, sorted.
  def all_blog_tags
    merged_blog_posts.flat_map { |e| entry_tags(e) }.uniq.sort
  end

  # Unique years from merged blog posts, descending.
  def all_blog_years
    merged_blog_posts.map { |e| e[:date].respond_to?(:year) ? e[:date].year : e[:date].to_time.year }.uniq.sort.reverse
  end

  # Giscus: https://giscus.app — see data/giscus.yaml. Optional: GISCUS_REPO_ID,
  # GISCUS_CATEGORY_ID env vars override YAML (e.g. CI) without committing ids.
  def giscus_data
    raw = (data.giscus rescue nil) || {}
    raw = raw.each_with_object({}) { |(k, v), h| h[k.to_s] = v }
    env = {}
    env["repo_id"] = ENV["GISCUS_REPO_ID"] if ENV["GISCUS_REPO_ID"].to_s.strip != ""
    env["category_id"] = ENV["GISCUS_CATEGORY_ID"] if ENV["GISCUS_CATEGORY_ID"].to_s.strip != ""
    {
      "mapping" => "pathname",
      "strict" => "0",
      "reactions_enabled" => "1",
      "emit_metadata" => "0",
      "input_position" => "bottom",
      "loading" => "lazy",
      "lang" => "en",
      "theme" => "preferred_color_scheme",
      "category" => "Comments"
    }.merge(raw).merge(env)
  end

  def giscus_embed_ready?
    g = giscus_data
    %w[repo repo_id category category_id].all? { |k| g[k].to_s.strip != "" }
  end

  # Top-level presentation pages only (not kaigi partials under presentations/kaigi/).
  def presentation_page?
    path = current_page.path.to_s
    path.start_with?("presentations/") && path.end_with?(".html") && path.split("/").length == 2
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
