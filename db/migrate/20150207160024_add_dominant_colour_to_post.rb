class AddDominantColourToPost < ActiveRecord::Migration
  def change
    add_column :posts, :dominant_header_colour, :string

    Post.where.not(header_image_uid: nil).each do |p|
      histogram = Histogram.new(p.header_image.path)
      p.dominant_header_colour = histogram.scores.first.last.hex
      p.save
    end
  end
end
