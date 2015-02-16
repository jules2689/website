class CreateFrontPageWidgets < ActiveRecord::Migration
  def change
    create_table :front_page_widgets do |t|
      t.string :title
      t.string :subtext
      t.string :url
      t.string :image_uid
      t.string :image_name

      t.timestamps
    end
  end
end
