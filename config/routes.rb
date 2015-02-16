Rails.application.routes.draw do

  devise_for :users, :skip => [:registrations]
  resources :posts, param: :handle
  resources :front_page_widgets, except: :show
  resources :images, only: :create

  controller :application do
    get "/me", to: :me, as: :me
  end

  resources :users do
    collection do
      resource :sessions, only: [:new, :create, :destroy]
    end
  end

  root "front_page_widgets#index"
end
