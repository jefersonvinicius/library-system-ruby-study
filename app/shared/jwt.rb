class Jwt
    SECRET = ENV['JWT_SECRET']

    class TokenDecoded
        attr_reader :id, :role, :exp

        def initialize(decoded_raw)
            @id = decoded_raw[0]['id']
            @role = decoded_raw[0]['role']
            @exp = decoded_raw[0]['exp']
        end

        def is_admin
            @role == User::ADMIN_ROLE
        end

        def to_h
            {id: @id, role: @role, exp: @exp}
        end
    end

    def self.sign_user(user)
        exp = Time.now.to_i + 1.day
        payload = {id: user.id, role: user.role, exp: exp}
        JWT.encode payload, SECRET, 'HS256'
    end

    def self.decode(token)
        begin
            decoded = JWT.decode token, SECRET, true
            TokenDecoded.new(decoded)
        rescue
            nil
        end
    end
end 
