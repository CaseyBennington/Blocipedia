Rails.application.routes.draw do
  resources :subscriptions, only: [:new, :create, :destroy, :update, :edit]
  resources :wikis do
    resources :collaborators, only: [:index, :destroy, :create]
  end

  mount StripeEvent::Engine, at: '/stripe/webhook'

  devise_for :users

  get 'about' => 'welcome#about'
  root 'welcome#index'
end
