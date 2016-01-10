class CleanUpTables < ActiveRecord::Migration
  def change
    drop_table :front_page_widgets
    drop_table :images
    remove_column :posts, :header_image_uid
    remove_column :posts, :header_image_name 
  end
end
