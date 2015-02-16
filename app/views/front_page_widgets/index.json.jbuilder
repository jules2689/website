json.array!(@front_page_widgets) do |front_page_widget|
  json.extract! front_page_widget, :id, :title, :subtext, :image_uid, :image_name
  json.url front_page_widget_url(front_page_widget, format: :json)
end
