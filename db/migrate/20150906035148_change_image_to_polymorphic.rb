class ChangeImageToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :images, :post_id, :owner_id
    add_column :images, :owner_type, :string
    Image.reset_column_information
    Image.update_all(:owner_type => "Post")
  end

  def down
    rename_column :images, :owner_id, :post_id
    remove_column :images, :owner_type
  end
end
