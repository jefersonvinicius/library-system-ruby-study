class BookModelView 
    include Rails.application.routes.url_helpers

    def initialize(book) 
        @book = book
    end

    def self.render(book)
        new(book).parse
    end

    def parse
        @book.as_json().tap do |result|
            result[:authors] = AuthorsModelView.render(@book.authors) if @book.authors.loaded? 
            result[:images] = images
        end
    end

    private
        def images
            @book.images.map { |image| url_for(image) }
        end
end
