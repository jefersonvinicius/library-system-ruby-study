class Borrowing < ApplicationRecord 

    DEFAULT_DAYS_FOR_BORROW = 7

    belongs_to :user
    belongs_to :book

    scope :pendents, -> { where(gave_back_at: nil) }
    scope :by_user, -> user { where(user_id: (user.is_a? User) ? user.id : user) }

    def is_late?
        Time.now > self.give_back_at && self.gave_back_at.nil?
    end

    def self.new_for(user:, book:) 
        borrowing = Borrowing.new({ user: user, book: book })
        borrowing.borrowed_at = Time.now
        borrowing.give_back_at = Time.now + DEFAULT_DAYS_FOR_BORROW.days
        borrowing.gave_back_at = nil

        borrowing
    end
end