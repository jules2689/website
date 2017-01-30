class AddMediumUrlToPost < ActiveRecord::Migration
  def change
    add_column :posts, :medium_url, :string
  end
end
