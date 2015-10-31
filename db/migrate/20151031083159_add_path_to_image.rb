class AddPathToImage < ActiveRecord::Migration
  def change
    add_column :images, :path, "VARCHAR(500)"
    add_column :images, :old_url, "VARCHAR(500)"

    Image.all.each do |i|
      i.path = "http://gitcdn.jnadeau.ca/images/website/public/#{i.image_uid}"
      i.old_url = i.url rescue ""
      i.save
    end
  end
end
