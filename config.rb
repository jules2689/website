# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

proxy(
  '/kaigi.html',
  '/presentations/kaigi.html'
)

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do
  def iterate_folder(folder, limit: -1, sort: nil)
    files = sitemap.resources.select do |s|
      File.dirname(s.path) == folder &&
      s.source_file.end_with?('.md', '.md.erb', '.html.erb', '.html') &&
      !s.source_file.include?('index.')
    end
    files = files.sort_by { |f| sort.call(f) } if sort
    files = files.take(limit) if limit > 0

    files.each do |page|
      yield(page)
    end
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
