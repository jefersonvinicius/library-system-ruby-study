require 'rails_helper'

RSpec.describe 'BorrowingModelView' do
    it 'should return correctly with user and book' do
        user = User.new(name: 'Any name')
        book = Book.new(title: 'Any title')
        borrowing = Borrowing.new_for user: user, book: book
    
        sut = BorrowingModelView.render(borrowing)

        expect(sut.with_indifferent_access).to match({
            id: nil,
            book_id: nil,
            borrowed_at: be_an(String),
            created_at: nil,
            gave_back_at: nil,
            give_back_at: be_an(String),
            updated_at: nil,
            user_id: nil,
            :book => {
                id: nil, 
                created_at: nil, 
                description: nil,
                edition: nil, 
                :images => [],
                released_at: nil,
                title: "Any title",
                updated_at: nil
            },
            :user => {
                created_at: nil, 
                email: nil, 
                id: nil,
                "name": "Any name",
                role: nil, 
                updated_at: nil
            },
        })
    end
end