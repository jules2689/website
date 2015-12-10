module ApplicationHelper
  def gravatar(email, gravatar_options = {})
    grav_url = 'https://www.gravatar.com/avatar.php?'
    grav_url << { gravatar_id: Digest::MD5.new.update(email), rating: gravatar_options[:rating], size: gravatar_options[:size], default: gravatar_options[:default] }.to_query
    grav_url
  end
end
