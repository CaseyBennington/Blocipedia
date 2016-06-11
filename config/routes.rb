Rails.application.routes.draw do
  resources :charges, only: [:new, :create]
  resources :wikis do
    resources :collaborators, only: [:index, :destroy, :create]
  end

  post 'downgrade' => 'charges#downgrade'

  devise_for :users

  get 'about' => 'welcome#about'
  root 'welcome#index'

  # mount EpicEditor::Engine => "/"
end
