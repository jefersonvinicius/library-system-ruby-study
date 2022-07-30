class BorrowingModelView
    def initialize(borrowing)
        @borrowing = borrowing
    end

    def self.render(borrowing)
        new(borrowing).render
    end

    def self.render_many(borrwings) 
        borrwings.map { |borrowing| new(borrowing).render }
    end

    def render
        @borrowing.as_json().tap do |tapping|
            tapping[:is_late] = @borrowing.is_late?
            tapping[:user] = UserModelView.render(@borrowing.user) if @borrowing.association(:user).loaded? 
            tapping[:book] = BookModelView.render(@borrowing.book) if @borrowing.association(:book).loaded?
        end
    end
end