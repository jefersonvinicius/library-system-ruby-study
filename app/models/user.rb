class User < ApplicationRecord
    include BCrypt
    
    has_many :borrowings
    has_many :books, through: :borrowings

    ADMIN_ROLE = 0
    READER_ROLE = 1

    before_create :hash_password

    validates :name, :email, :password, presence: true
    validates :password, length: { minimum: 6 }

    def password_matches?(with: ) 
        Password.new(self.password) == with
    end

    private 
        def hash_password
            self.password = Password.create(self.password) 
        end
end
