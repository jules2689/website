class AddCounterCacheToCategorys < ActiveRecord::Migration
  def change
    add_column :post_categories, :posts_count, :integer

    PostCategory.find_each { |post_category| PostCategory.reset_counters(post_category.id, :posts) }
  end
end
