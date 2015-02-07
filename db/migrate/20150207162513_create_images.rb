class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image_uid
      t.string :image_name
      t.string :title
      t.string :width
      t.string :dominant_colour
      t.references :post
      t.timestamps
    end
  end
end
