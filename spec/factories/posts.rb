FactoryBot.define do
  factory :post do |user|
    title { "Test Post" }
    content { "Content to test post." }
    user

    trait :unpublished do
      title { "Test Unpublished Post" }
      published { false }
    end
  end
end
