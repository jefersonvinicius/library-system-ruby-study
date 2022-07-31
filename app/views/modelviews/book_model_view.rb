class BookModelView 
    include Rails.application.routes.url_helpers

    def initialize(book) 
        @book = book
    end

    def self.render(book)
        new(book).render
    end
    
    def self.render_many(books) 
        books.map { |book| new(book).render }
    end

    def render
        @book.as_json().tap do |result|
            result[:authors] = AuthorModelView.render_many(@book.authors) if @book.authors.loaded? 
            result[:images] = images
        end
    end

    private
        def images
            @book.images.map { |image| url_for(image) }
        end
end
