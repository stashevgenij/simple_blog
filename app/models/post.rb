class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  attr_accessor :do_not_publish

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(published: true) }

  def do_not_publish=(value)
    self.published = value == "1" ? false : true
  end
end
