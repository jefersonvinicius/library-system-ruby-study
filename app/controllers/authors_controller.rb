class AuthorsController < BaseController
  def index
    @all_authors_count = Author.count
    @authors = Author.includes(:books).offset(offset).limit(PER_PAGE).with_attached_images

    @meta = make_meta total_records: @all_authors_count
    render json: {authors: AuthorsModelView.new(@authors).view, meta: @meta}
  end

  def show
    @author = Author.find_by id: params[:id]
    render json: {author: AuthorModelView.new(@author).view}
  end

  def create
    @author = Author.new(creation_params)
    books = Book.where id: author_params[:book_ids]
    @author.books = books

    if @author.save
      render json: {author: @author}
    else
      render status: :unprocessable_entity
    end
  end

  def update

  end

  private 
    def author_params
      params.permit(:name, :bio, :birth_date, :images, book_ids: [])
    end

    def edition_params
      
    end

    def creation_params
      author_params.except(:book_ids)
    end
end
