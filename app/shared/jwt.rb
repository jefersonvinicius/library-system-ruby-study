class Jwt
    SECRET = ENV['JWT_SECRET']

    def self.sign_user(user)
        exp = Time.now.to_i + 1.day
        payload = {id: user.id, role: user.role, exp: exp}
        JWT.encode payload, SECRET, 'HS256'
    end
end 
