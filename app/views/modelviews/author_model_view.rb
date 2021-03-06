class AuthorModelView 
    include Rails.application.routes.url_helpers

    def initialize(author) 
        @author = author
    end

    def self.render(author)
        new(author).parse
    end

    def parse
        @author.as_json(include: [:books]).tap do |result|
            result[:images] = images
        end
    end

    private
        def images
            @author.images.map { |image| url_for(image) }
        end
end
