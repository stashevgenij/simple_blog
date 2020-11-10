class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  scope :ordered,   -> { order(created_at: :desc) }
end
