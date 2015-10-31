class FrontPageWidget < ActiveRecord::Base
  include HasImage
  default_scope { order(position: :asc) }
  validates_presence_of :title, :url, :image_url, :image_name
end
