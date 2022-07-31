class BorrowingsController < ApplicationController 
    before_action :auth_admin
    before_action :set_user, only: [:borrow, :index_user_borrowings, :give_back_book]
    before_action :set_book, only: [:borrow, :give_back_book]

    MAX_BOOKS_PER_USER = 5

    def index_user_borrowings
        @borrowings = Borrowing.includes(:book).by_user(@user)

        render json: { borrowings: BorrowingModelView.render_many(@borrowings) }
    end

    def borrow
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

    def give_back_book
        @borrowing = Borrowing.by_user(@user).by_book(@book).first
        return render_not_found Borrowing, user_id: @user.id, book_id: @book.id if @borrowing.nil?

        @borrowing.give_back

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

        def set_user
            @user = User.find_by id: index_user_borrowings_params[:user_id]
            return render_not_found User, id: borrow_params[:user_id] if @user.nil?
        end

        def set_book

            @book = Book.find_by id: borrow_params[:book_id]
            return render_not_found Book, id: borrow_params[:book_id] if @book.nil?
        end

        def index_user_borrowings_params
            params.permit(:user_id)
        end

        def user_already_have_book?
            @user_borrowings.any? { |borrowing| borrowing.book_id == @book.id && borrowing.gave_back? } 
        end
end