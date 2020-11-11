FactoryBot.define do
  factory :comment do
    text { 'Test comment.' }
    user { user }
    post { post }
  end
end
