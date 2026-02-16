# Source directory – agents

- **Blog posts**: Add markdown files with YAML front matter in `source/blog/` using the filename pattern `YYYY-MM-DD-slug.html.markdown`. Required front matter: `title`, optional: `date`, `description`, `social_image`, `social_image_alt`. Posts are rendered by middleman-blog and appear automatically in the Writing section on the home page.
- **Writing section**: Rendered by `partials/_blog.html.erb`, which shows local blog articles first (`blog.articles`), then external posts from `data/blog.json`. The card partial expects `link`, `image`, `year`, `type`, `title`, `description`; optional `image_title`, `image_attributes`.
- **Blog index**: With `blog.prefix = "blog"` and directory_indexes, the blog index is `source/blog/index.html.erb`; it is served at `/blog/`. Use the same section/card layout as the home Writing section for consistency.
- **Blog layout**: Articles use `blog_layout` (set in config.rb). The layout uses `current_article` to show article title and date in the page header; inner pages use `partial "partials/nav"` for Home and Blog links.
