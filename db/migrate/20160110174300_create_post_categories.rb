class CreatePostCategories < ActiveRecord::Migration
  def change
    create_table :post_categories do |t|
      t.string :title, index: true
      t.timestamps
    end

    pc = PostCategory.create(title: "Default")

    add_column :posts, :post_category_id, :integer, references: :post_categories

    Post.unscoped.all.each { |p| p.update_attribute(:post_category_id, pc.id) }
  end
end
