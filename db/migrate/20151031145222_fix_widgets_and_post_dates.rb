class FixWidgetsAndPostDates < ActiveRecord::Migration
  def change
    add_column :front_page_widgets, :image_url, "VARCHAR(500)"

    FrontPageWidget.all.each do |w|
      if w.image_uid.present?
        w.image_url = "http://gitcdn.jnadeau.ca/images/website/public/#{w.image_uid}"
        w.save
      end
    end

    Post.all.each do |p|
      p.updated_at = p.created_at
      p.save
    end
  end
end
