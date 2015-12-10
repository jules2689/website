module InterestsHelper
  def embed(url)
    "<iframe src='#{url}?controls=0' height='200px' width='100%'
                    frameborder='0'
                    scrolling='no' seamless webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>".html_safe
  end

  def interest_metadata(provider, interest_type)
    [interest_type.try(:humanize), provider].reject(&:blank?).join("/")
  end
end
