Rails.application.routes.draw do
  devise_for :users
  root "posts#index"
  get 'my_posts' => 'posts#my_posts'
  resources :posts, except: :index do
    resources :comments, only: :create
  end
  resources :comments, only: [ :edit, :update, :destroy ]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
