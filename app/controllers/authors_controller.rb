class AuthorsController < ApplicationController
  before_action :auth_admin
  before_action :set_current_author, only: [:update, :show, :detach_book, :attach_book]

  def index
    @all_authors_count = Author.count
    @authors = Author.includes(:books).offset(offset).limit(PER_PAGE).with_attached_images

    @meta = make_meta total_records: @all_authors_count
    render json: {authors: AuthorModelView.render_many(@authors), meta: @meta}
  end

  def show
    render json: {author: AuthorModelView.render(@author)}
  end

  def create
    @author = Author.new(creation_params)
    books = Book.where id: author_params[:book_ids]
    @author.books = books

    if @author.save
      render json: {author: AuthorModelView.render(@author)}
    else
      render status: :unprocessable_entity
    end
  end

  def update
    if @author.update(edition_params)
      render json: {author: AuthorModelView.render(@author)}
    else
      render status: :unprocessable_entity
    end
  end

  def detach_book
    @author.books.delete(params[:book_id])
    render json: {author: AuthorModelView.render(@author)}
  end

  def attach_book
    if !@author.books.exists?(params[:book_id])
      book = Book.find params[:book_id]
      @author.books << book
    end
    render json: {author: AuthorModelView.render(@author)}
  end

  private 

    def set_current_author
      @author = Author.includes(:books).find_by id: params[:id]    
      return render_not_found id: params[:id] if @author.nil? 
    end

    def author_params
      params.permit(:name, :bio, :birth_date, :images, book_ids: [])
    end

    def edition_params
      author_params.except(:book_ids)
    end

    def creation_params
      author_params.except(:book_ids)
    end
end
