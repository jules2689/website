class AddImageUrlToInterest < ActiveRecord::Migration
  def change
    add_column :interests, :image_url, "VARCHAR(500)"

    Interest.all.each do |i|
      images = Image.where(owner_id: i.id, owner_type: "Interest")
      if images.present?
        i.image_url = images.first.old_url
        i.save
      end
    end
  end
end
