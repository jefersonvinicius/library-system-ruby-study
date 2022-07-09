class AuthorsModelView 
    def initialize(authors) 
        @authors = authors
    end

    def self.render(authors)
        new(authors).parse
    end

    def parse
        @authors.map { |author| AuthorModelView.render(author) }
    end
end