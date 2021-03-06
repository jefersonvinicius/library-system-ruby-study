class BooksController < ApplicationController
  before_action :auth_admin
  before_action :set_current_book, only: [:show, :update, :attach_author, :detach_author]

  def index
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

  def update
    if @book.update(edition_params)
      render json: {book: BookModelView.render(@book)}
    else
      render status: :unprocessable_entity
    end
  end

  def attach_author
    if !@book.authors.exists?(params[:author_id])
      author = Author.find_by id: params[:author_id]
      @book.authors << author  
    end
    render json: {book: BookModelView.render(@book)}
  end

  def detach_author
    if @book.authors.exists? params[:author_id]
      @book.authors.delete(params[:author_id])
    end
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

    def edition_params
      book_params.except(:images)
    end
end