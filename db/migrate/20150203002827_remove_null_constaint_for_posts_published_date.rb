class RemoveNullConstaintForPostsPublishedDate < ActiveRecord::Migration
  def change
    change_column :posts, :published_date, :datetime, null: true
  end
end
