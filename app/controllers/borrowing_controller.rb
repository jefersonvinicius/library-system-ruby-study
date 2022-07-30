class BorrowingController < ApplicationController 
    before_action :auth_admin

    MAX_BOOKS_PER_USER = 5

    def borrow
        @user = User.find_by id: borrow_params[:user_id]
        return render_not_found User, id: borrow_params[:user_id] if @user.nil?

        @book = Book.find_by id: borrow_params[:book_id]
        return render_not_found Book, id: borrow_params[:book_id] if @book.nil?

        @user_borrowings = Borrowing.by_user(@user)

        if !@user.password_matches? with: borrow_params[:password]
            return render json: {message: "User password wrong"}, status: :forbidden
        end

        if @user_borrowings.length >= MAX_BOOKS_PER_USER
            return render json: {message: "The user #{@user.id} already have #{MAX_BOOKS_PER_USER} books"}, status: :forbidden
        end

        if user_already_have_book?
            return render json: {message: "The user #{@user.id} already have the book #{@book.id}"}, status: :conflict
        end

        @borrowing = Borrowing.new_for user: @user, book: @book
        if @borrowing.save
            render json: {borrowing: BorrowingModelView.render(@borrowing)}
        else 
            render json: {errors: @borrowing.errors}, status: :unprocessable_entity
        end
    end

    private
        def borrow_params
            params.permit(:password, :user_id, :book_id)
        end

        def user_already_have_book?
            @user_borrowings.any? { |borrowing| borrowing.book_id == @book.id } 
        end
end