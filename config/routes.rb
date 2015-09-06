Rails.application.routes.draw do

  resources :interests, only: [:index, :new, :create, :destroy]

  devise_for :users, :skip => [:registrations]
  resources :posts, param: :handle
  resources :front_page_widgets, except: :show do
    collection do
      get "/positions", to: :positions, as: :positions
      post "/positions", to: :save_positions, as: :save_positions
    end
  end
  resources :images, only: :create

  resources :users do
    collection do
      resource :sessions, only: [:new, :create, :destroy]
    end
  end

  root "front_page_widgets#index"
end
