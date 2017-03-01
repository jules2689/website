Rails.application.routes.draw do
  concern :tag_resources do
    collection { get :tags }
  end

  resources :interests, concerns: :tag_resources, only: [:index, :new, :create, :destroy]

  resources :posts, concerns: :tag_resources, param: :handle do
    member { post :regenerate_published_key }
    collection { post :create_medium_post }
  end

  controller :images, path: "images" do
    post :create_github_image
    post :create_gallery
  end

  controller :diatex, path: "diatex" do
    get :latex
    get :diagram
  end

  devise_for :users, skip: [:registrations]
  resources :users do
    collection do
      resource :sessions, only: [:new, :create, :destroy]
    end
  end

  root "application#index"
end
