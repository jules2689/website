class FixWidgetsAndPostDates < ActiveRecord::Migration
  def change
    add_column :front_page_widgets, :image_url, "VARCHAR(500)"
  end
end
