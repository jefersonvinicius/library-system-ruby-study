class BooksController < BaseController

  def index
    @page = params.fetch(:page, 1).to_i
    @all_books_count = Book.count
    @books = Book.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)

    @images = Hash.new
    @books.each { |book| 
      @images.merge!("#{book.id}": book.images.map { |image| url_for(image)}) if book.images.attached?
    }

    @meta = make_meta total_records: @all_books_count, page: @page
    render json: {books: @books, images: @images, meta: @meta}
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
end