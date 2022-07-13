class UsersController < BaseController

    include BCrypt

    def signup_admin
        @user_exists = User.find_by email: signup_params[:email]
        return render_already_exists email: signup_params[:email] unless @user_exists.nil?
 
        @user = User.new(admin_signup_params)
        if @user.save
            render json: {user: UserModelView.render(@user)}
        else
            render status: :unprocessable_entity
        end
    end


    private

        def admin_signup_params
            signup_params.merge(role: User::ADMIN_ROLE, password: Password.create(signup_params[:password]))
        end

        def signup_params
            params.permit(:name, :email, :password)
        end
end