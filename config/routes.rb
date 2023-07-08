Rails.application.routes.draw do
  resources :users, only: [] do
    resources :follows, param: :followed_user_id, only: %i(create destroy)
    resources :sleeps, only: %i(create update)
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
