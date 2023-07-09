Rails.application.routes.draw do
  resources :users, only: [] do
    resources :follows, param: :followed_user_id, only: %i(create destroy)
    resources :sleeps, only: %i(index create update)
    resources :following_sleeps, only: %i(index)
  end

  root to: "sleeps#index", user_id: 1, defaults: { format: :json }
end
