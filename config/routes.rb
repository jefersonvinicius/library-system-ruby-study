Rails.application.routes.draw do
  get 'authors/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope'api' do
    scope'v1' do
      post 'admins/signup', to: 'users#signup_admin'
      post 'readers/signup', to: 'users#signup_reader'
      post 'login', to: 'users#login'

      get 'books', to: 'books#index'
      get 'books/:id', to: 'books#show'
      put 'books/:id', to: 'books#update'
      post 'books', to: 'books#create'
      post 'books/:id/authors/:author_id', to: 'books#attach_author'
      delete 'books/:id/authors/:author_id', to: 'books#detach_author'

      get 'authors', to: 'authors#index'
      get 'authors/:id', to: 'authors#show'
      post 'authors', to: 'authors#create'
      put 'authors/:id', to: 'authors#update'
      delete 'authors/:id/books/:book_id', to: 'authors#detach_book'
      post 'authors/:id/books/:book_id', to: 'authors#attach_book'

      post 'borrowings/users/:user_id/books/:book_id', to: 'borrowings#borrow'
      get 'borrowings/users/:user_id', to: 'borrowing#index_user_borrowings'
      delete 'borrowings/users/:user_id/books/:book_id', to: 'borrowings#give_back_book'
    end
  end
end
