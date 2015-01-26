Rails.application.routes.draw do
  resources :posts, param: :handle
  controller :application do
    get "/me", to: :me, as: :me
  end

  root "application#index"
end
