class UserModelView
    def initialize(user)
        @user = user
    end

    def self.render(user)
        new(user).render
    end

    def render
        @user.as_json(except: :password)
    end
end