class PostCategory < ActiveRecord::Base
  has_many :posts
  validates :title, uniqueness: true
end
