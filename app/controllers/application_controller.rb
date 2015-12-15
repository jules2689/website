class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
    
  def authenticate_user_from_token!
    user_token = params[:user_token].presence
    user = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      sign_in user, store: false
    elsif params[:use_html_auth].blank?
      head :unauthorized
    end
  end
end
