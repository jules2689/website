class AddPublishedDateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published_date, :datetime, null: false, default: 1.day.ago
  end
end
