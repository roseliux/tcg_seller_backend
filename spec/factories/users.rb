FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password123456" }
    password_confirmation { "password123456" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:user_name) { |n| "user_#{n}" }
    verified { true }

    trait :unverified do
      verified { false }
    end

    trait :john_doe do
      email { "john.doe@example.com" }
      first_name { "John" }
      last_name { "Doe" }
      user_name { "john_doe" }
    end

    trait :jane_smith do
      email { "jane.smith@example.com" }
      first_name { "Jane" }
      last_name { "Smith" }
      user_name { "jane_smith" }
    end
  end
end
