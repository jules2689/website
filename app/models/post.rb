class Post < ActiveRecord::Base
  default_scope { order(updated_at: :desc) }
  acts_as_ordered_taggable

  validates_presence_of :title, :body
  before_validation :set_handle

  def est_created_at
    self.created_at + Time.zone_offset('EST')
  end

  def est_updated_at
    self.updated_at + Time.zone_offset('EST')
  end

  def trancated_body
    html_body.html_truncate(200)
  end

  def html_body
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(body).html_safe
  end

  def to_param
    handle
  end

  private

  def set_handle
    self.handle = self.title.downcase.parameterize
  end

end
