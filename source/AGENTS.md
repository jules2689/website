# Source directory – patterns for agents

- **Blog posts**: Front matter in `source/blog/*.html.markdown` supports `title`, `date`, `description`, `social_image`, and **tags** (YAML list, e.g. `tags: [devops, ruby]`). Tags appear on cards and drive blog index filtering.
- **Blog index**: Filtering is client-side. Cards get `data-year` and `data-tags` (space-separated) from `blog_post_card`; tag/year pills and filter logic are in `source/blog/index.html.erb`. Helpers `entry_tags`, `all_blog_tags`, `all_blog_years` live in `config.rb`.
- **External posts (data/blog.json)**: Each entry can have `tags` as array or comma-separated string; `tag_list` (array) is also supported. Use array format for new entries so `entry_tags` returns correct list.
