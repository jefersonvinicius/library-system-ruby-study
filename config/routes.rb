Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope'api' do
    scope'v1' do
      get 'books', to: 'books#index'
      post 'books', to: 'books#create'
    end
  end
end
