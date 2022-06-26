class Book < ApplicationRecord
    has_many_attached :images
    has_and_belongs_to_many :authors
end
