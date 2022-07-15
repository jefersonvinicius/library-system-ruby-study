class UsersController < BaseController

    include BCrypt

    def signup_admin
        signup role: User::ADMIN_ROLE
    end


    def signup_reader
        signup role: User::READER_ROLE
    end

    def login
        @user = User.find_by email: signup_params[:email]
        return render json: {message: 'Invalid credentials'}, status: :unauthorized if is_unauthorized

        @access_token = Jwt.sign_user(@user)
        render json: {user: UserModelView.render(@user), access_token: @access_token}
    end

    private

        def signup(role:) 
            final_params = signup_params.merge({role: role, password: Password.create(signup_params[:password])})

            @user_exists = User.find_by email: final_params[:email]
            return render_already_exists email: final_params[:email] unless @user_exists.nil?
    
            @user = User.new(final_params)
            @access_token = Jwt.sign_user(@user)
            if @user.save
                render json: {user: UserModelView.render(@user), access_token: @access_token}
            else
                render status: :unprocessable_entity
            end
        end

        def is_unauthorized
            @user.nil? || Password.new(@user.password) != login_params[:password]
        end

        def signup_params
            params.permit(:name, :email, :password)
        end

        def login_params
            params.permit(:email, :password)
        end
end