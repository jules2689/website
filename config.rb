activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :directory_indexes
set :relative_links, true

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

redirect 'kaigi.html', to: 'presentations/rubykaigi2017.html'

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
