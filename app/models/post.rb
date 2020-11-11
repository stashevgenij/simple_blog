class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title,   presence: true
  validates :content, presence: true

  scope :published, -> { where(published: true) }

  def do_not_publish=(value)
    self.published = !(value == '1')
  end

  def tags_string=(string)
    self.tags = string.split(',').map do |tag_name|
      Tag.where(tag_name: tag_name.strip).first_or_create!
    end
  end

  def tags_string
    tags.map(&:tag_name).join(', ')
  end
end
