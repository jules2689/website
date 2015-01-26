class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_sidebar_content

  private

  def set_sidebar_content
    @tags = ActsAsTaggableOn::Tag.most_used(8)
    @recents = Post.limit(5)
  end
end
