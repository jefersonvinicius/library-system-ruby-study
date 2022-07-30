class BorrowingModelView
    def initialize(borrowing)
        @borrowing = borrowing
    end

    def self.render(borrowing)
        new(borrowing).render
    end

    def render
        @borrowing.as_json().merge({
            user: UserModelView.render(@borrowing.user),
            book: BookModelView.render(@borrowing.book),
        })
    end
end