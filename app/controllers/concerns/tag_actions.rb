module TagActions
  def tags
    tag_ids = ActsAsTaggableOn::Tagging.where(taggable_type: controller_path.classify).collect(&:tag_id).uniq
    @tags = ActsAsTaggableOn::Tag.where("LOWER(name) LIKE LOWER(:query)", query: "%#{params['query']}%").where(id: tag_ids)
    render json: { suggestions: @tags.collect(&:name) }
  end
end
