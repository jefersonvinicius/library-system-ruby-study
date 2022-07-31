class BorrowingModelView
    def initialize(borrowing)
        @borrowing = borrowing
    end

    def self.render(borrowing)
        new(borrowing).render
    end

    def self.render_many(borrowings) 
        borrowings.map { |borrowing| new(borrowing).render }
    end

    def render
        @borrowing.as_json().tap do |tapping|
            tapping[:is_late] = @borrowing.is_late?
            tapping[:gave_back] = @borrowing.gave_back?
            tapping[:user] = UserModelView.render(@borrowing.user) if @borrowing.association(:user).loaded? 
            tapping[:book] = BookModelView.render(@borrowing.book) if @borrowing.association(:book).loaded?
        end
    end
end