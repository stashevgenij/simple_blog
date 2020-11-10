class Post < ApplicationRecord
  belongs_to :user

  attr_accessor :do_not_publish

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(published: true) }
  scope :ordered,   -> { order(created_at: :desc) }

  def do_not_publish=(value)
    self.published = value == "1" ? false : true
  end
end
