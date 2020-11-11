class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :text, presence: true, length: { minimum: 1, maximum: 600 }

  def editable?
    Time.now - created_at < 15.minutes
  end

  def update_by(params, _user)
    update(params) if validate_is_editable
  end

  def destroy_by(_user)
    destroy if validate_is_editable
  end

  private

  def validate_is_editable
    if persisted? && !editable?
      errors[:editable] << 'can edit/delete in just 15 minutes after creation'
      false
    else
      true
    end
  end
end
