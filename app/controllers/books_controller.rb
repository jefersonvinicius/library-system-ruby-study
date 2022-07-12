class BooksController < BaseController
  before_action :set_current_book, only: [:show]

  def index
    @page = params.fetch(:page, 1).to_i
    @all_books_count = Book.count
    @books = Book.includes(:authors).offset(offset).limit(PER_PAGE).with_attached_images

    @meta = make_meta total_records: @all_books_count
    render json: {books: BooksModelView.render(@books), meta: @meta}
  end

  def create
    @book = Book.new(book_params)
    @book.images.attach(params[:images])

    if @book.save
      render json: {book: BookModelView.render(@book)}
    else 
      render status: :unprocessable_entity
    end
  end

  def show
    render json: {book: BookModelView.render(@book)}
  end

  private 

    def set_current_book
      @book = Book.find_by id: params[:id]
      return render_not_found id: params[:id] if @book.nil?
    end

    def book_params
      params.permit(:title, :description, :released_at, :edition, :images)
    end
end