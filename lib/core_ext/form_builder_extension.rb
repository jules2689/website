class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::AssetTagHelper

  def markdown_input(method, options = {})
    out = "<div id=\"wmd-button-bar-#{method}\"></div>\n"
    out << "#{text_area(method, options.merge(
      class: 'wmd-input', id: "wmd-input-#{method}"))}"
    if options[:preview]
      out << "<div id=\"wmd-preview-#{method}\" class=\"wmd-preview\"></div>"
    end
    out.html_safe
  end
end
