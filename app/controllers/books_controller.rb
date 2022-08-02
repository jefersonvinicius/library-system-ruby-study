class BooksController < ApplicationController
  before_action :auth_admin
  before_action :set_current_book, only: [:show, :update, :attach_author, :detach_author, :attach_image, :detach_image, :sort_image]
  before_action :set_image, only: [:sort_image, :detach_image]

  def index
    @all_books_count = Book.count
    @books = Book.includes(:authors).offset(offset).limit(PER_PAGE).with_attached_images

    @meta = make_meta total_records: @all_books_count
    render json: {books: BookModelView.render_many(@books), meta: @meta}
  end

  def create
    @book = Book.new(book_params)
    @book.images.attach(params[:images])

    if @book.save
      render json: {book: BookModelView.render(@book)}
    else 
      render json: {errors: @book.errors}, status: :unprocessable_entity
    end
  end

  def show
    @book.images.order(:position)
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

  def attach_image
    @book.attach_positioned(params[:image])
    
    render json: {author: BookModelView.render(@book)}
  end

  def detach_image
    @book.purge_positioned(@image)
  end

  def sort_image
    changed = Sorting.sort models: @book.images, changing: @image, to: params[:index].to_i
    ApplicationRecord.save_many(changed)
    render json: {book: BookModelView.render(@book)}
  end

  private 

    def set_current_book
      @book = Book.with_attached_images.includes(:authors).find_by id: params[:id]
      return render_not_found Book, id: params[:id] if @book.nil?
    end

    def set_image
      @image = @book.images.find_by id: params[:image_id]
      return render_not_found 'Image', image_id: params[:image_id] if @image.nil?
    end

    def book_params
      params.permit(:title, :description, :released_at, :edition, :images)
    end

    def edition_params
      book_params.except(:images)
    end
end