class AddPublishedKeyToPost < ActiveRecord::Migration
  def change
    add_column :posts, :published_key, :string

    Post.all.each do |p|
      p.touch
      p.save
    end
  end
end
