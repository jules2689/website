class FixInterests < ActiveRecord::Migration
  def change
    Interest.all.each do |i|
      images = Image.where(owner_id: i.id, owner_type: "Interest")
      if images.present?
        i.image_url = "http://gitcdn.jnadeau.ca/images/website/public/#{images.first.image_uid}"
        i.save
      end
    end
  end
end
