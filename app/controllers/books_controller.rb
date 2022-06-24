class BooksController < ApplicationController
  
  PER_PAGE = 5

  def index
    @page = params.fetch(:page, 1).to_i
    @all_books_count = Book.count
    @books = Book.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)

    # @books.each { |book| book.image = url_for(book.images) }
    # puts @images
    
    @meta = make_meta(@all_books_count, @page)
    render json: {books: @books, meta: @meta}
  end

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

    def make_meta(total_records, page)
      @total_pages = (total_records / PER_PAGE).ceil + 1
      return {
        first_page: [0, 1].include?(page),
        last_page: page >= @total_pages,
        total_pages: @total_pages,
      }
    end
end