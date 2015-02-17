class AddPositionToWidgets < ActiveRecord::Migration
  def change
    add_column :front_page_widgets, :position, :integer
  end
end
