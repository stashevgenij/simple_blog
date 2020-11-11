class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings

  validates :tag_name, presence: true, uniqueness: { case_sensitive: false }
end
