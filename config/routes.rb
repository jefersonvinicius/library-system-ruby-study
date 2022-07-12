Rails.application.routes.draw do
  get 'authors/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope'api' do
    scope'v1' do
      get 'books', to: 'books#index'
      get 'books/:id', to: 'books#show'
      post 'books', to: 'books#create'

      get 'authors', to: 'authors#index'
      get 'authors/:id', to: 'authors#show'
      post 'authors', to: 'authors#create'
      put 'authors/:id', to: 'authors#update'
      delete 'authors/:id/books/:book_id', to: 'authors#detach_book'
      post 'authors/:id/books/:book_id', to: 'authors#attach_book'
    end
  end
end
