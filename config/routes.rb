Rails.application.routes.draw do
  root 'videos#index'
  resources :videos do
    collection do
      get :all_delete
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
