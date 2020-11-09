FactoryBot.define do
  factory :post do |user|
    title { "Test Post" }
    content { "Content to test post." }
    user { create :user }
  end
end
