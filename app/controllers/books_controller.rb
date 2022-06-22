class BooksController < ApplicationController
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: {book: @book}
    else 
      render status: :unprocessable_entity
    end
  end

  private 
    def book_params
      params.require(:book).permit(:title, :description, :released_at, :edition)
    end
end