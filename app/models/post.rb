class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :taggins, dependent: :destroy
  has_many :tags, through: :taggings

  attr_accessor :do_not_publish

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(published: true) }

  def do_not_publish=(value)
    self.published = value == "1" ? false : true
  end

  def tags_string=(string)
    self.tags = string.split(',').map do |name|
      Tag.where(name: tag_name.strip).first_or_create!
    end
  end

  def tags_string
    tags.map(&:tag_name).join(', ')
  end
end
