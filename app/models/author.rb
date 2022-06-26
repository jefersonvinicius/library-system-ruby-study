class Author < ApplicationRecord
    has_many_attached :images
    has_and_belongs_to_many :books
end
