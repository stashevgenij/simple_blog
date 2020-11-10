class Tag < ApplicationRecord
  has_many :taggins, dependent: :destroy
  has_many :posts, through: :taggings
end
