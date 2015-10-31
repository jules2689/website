class AddHeaderImageUrlToPost < ActiveRecord::Migration
  def change
    add_column :posts, :header_image_url, "VARCHAR(500)"

    Post.all.each do |p|
      if p.header_image_uid.present?
        p.header_image_url = "http://gitcdn.jnadeau.ca/images/website/public/#{p.header_image_uid}"
        p.save
      end
    end
  end
end
