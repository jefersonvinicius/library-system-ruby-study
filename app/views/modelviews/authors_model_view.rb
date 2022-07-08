class AuthorsModelView 
    def initialize(authors) 
        @authors = authors
    end

    def view
        @authors.map { |author| AuthorModelView.new(author).view }
    end
end