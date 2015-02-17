class FrontPageWidget < ActiveRecord::Base
  default_scope { order(position: :asc) }
  dragonfly_accessor :image
  validates_presence_of :title, :url, :image
end
