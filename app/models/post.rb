class Post < ApplicationRecord
    has_one_attached :public_image, service: :public
    has_one_attached :private_image, service: :private
end
