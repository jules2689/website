class SwitchCdnLink < ActiveRecord::Migration
  def change
    old = "http://gitcdn.jnadeau.ca"
    newLink = "https://jules2689.github.io/gitcdn"

    FrontPageWidget.all.each do |w|
      if w.image_url.present?
        puts "Updating Widget..."
        w.image_url = w.image_url.gsub(/#{old}/, newLink)
        w.save
      end
    end

    Interest.all.each do |w|
      if w.image_url.present?
        puts "Updating Interest..."
        w.image_url = w.image_url.gsub(/#{old}/, newLink)
        w.save
      end
    end

    Post.all.each do |w|
      if w.header_image_url.present?
        puts "Updating Post..."
        w.header_image_url = w.header_image_url.gsub(/#{old}/, newLink)
        w.updated_at = w.created_at
        w.save
      end
    end

    Image.all.each do |w|
      if w.path.present?
        puts "Updating Image..."
        w.path = w.path.gsub(/#{old}/, newLink)
        w.save
      end
    end

  end
end
