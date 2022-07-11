class BooksModelView 
    def initialize(books) 
        @books = books
    end

    def self.render(books)
        new(books).parse
    end

    def parse
        @books.map { |book| BookModelView.render(book) }
    end
end