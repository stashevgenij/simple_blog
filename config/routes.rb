Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get 'my_posts' => 'posts#my_posts'
  resources :posts do
    resources :comments, only: [:create, :update]
  end
  resources :comments, only: [ :edit, :destroy ]
  resources :tags, only: [] do
    member do
      get 'posts'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
