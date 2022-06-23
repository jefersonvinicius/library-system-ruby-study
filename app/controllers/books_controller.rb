class BooksController < ApplicationController
  
  def create
    @book = Book.new(book_params)
    @book.images.attach(params[:images])

    if @book.save
      render json: {book: @book}
    else 
      render status: :unprocessable_entity
    end
  end

  private 
    def book_params
      params.permit(:title, :description, :released_at, :edition, :images)
    end
end