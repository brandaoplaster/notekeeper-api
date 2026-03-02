FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { nil }

    trait :with_content do
      content { Faker::Lorem.paragraph }
    end
  end
end
