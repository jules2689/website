class AddHeaderImageToPost < ActiveRecord::Migration
  def change
    add_column :posts, :header_image_uid,  :string
    add_column :posts, :header_image_name, :string
  end
end
