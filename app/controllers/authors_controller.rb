class AuthorsController < BaseController
  def create
    puts params[:books_ids]
    @author = Author.new(author_params)
    @author.images.attach(params[:images])
    @author.book_ids << params[:books_ids]

    if @author.save
      render json: {author: @author}
    else
      render status: :unprocessable_entity
    end
  end

  private 
    def author_params
      params.permit(:name, :bio, :birth_date, :images, :books_ids)
    end
end
