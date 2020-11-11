FactoryBot.define do
  factory :tag do
    sequence(:tag_name) { |n| "tag#{n}" }

    after(:create) do |tag|
      user = create :user
      tag.posts << create_list(:post, 2, user: user)
    end
  end
end
