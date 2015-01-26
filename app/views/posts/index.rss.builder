xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Julian Nadeau"
    xml.description "My random, incoherent thoughts."
    xml.link "http://jnadeau.ca"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link post_url(post)
        xml.description strip_tags post.trancated_body
        xml.pubDate Time.parse(post.created_at.to_s).rfc822()
        xml.guid post_url(post)
      end
    end
  end
end
