Rails.application.routes.draw do
  resources :charges, only: [:new, :create]
  resources :wikis

  post 'downgrade' => 'charges#downgrade'

  devise_for :users

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
