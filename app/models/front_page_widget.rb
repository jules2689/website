class FrontPageWidget < ActiveRecord::Base
  dragonfly_accessor :image
  validates_presence_of :title, :subtext, :url, :image
end
