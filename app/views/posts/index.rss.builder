xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title Rails.application.app_config.website_title
    xml.description strip_tags(Rails.application.app_config.website_tagline)
    xml.link request.protocol + request.host_with_port

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link post_url(post)
        xml.description post.html_body
        xml.pubDate Time.parse(post.created_at.to_s).rfc822()
        xml.guid post_url(post)
      end
    end
  end
end
