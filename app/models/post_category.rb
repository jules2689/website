class PostCategory < ActiveRecord::Base
  has_many :posts
  validates :title, uniqueness: true
  validates :title, length: { minimum: 5, maximum: 50 }
end
