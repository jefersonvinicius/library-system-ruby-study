class AuthorModelView < BaseModelView
    include Rails.application.routes.url_helpers

    def initialize(author) 
        @author = author
    end

    def self.render(author)
        new(author).render
    end

    def self.render_many(authors)
        authors.map { |author| new(author).render }
    end

    def render
        @author.as_json().tap do |result|
            result[:books] = BookModelView.render_many(@author.books) if @author.books.loaded?
            result[:images] = render_images(@author)
        end
    end
end
