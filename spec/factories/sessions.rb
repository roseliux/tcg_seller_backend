FactoryBot.define do
  factory :session do
    user

    trait :with_device_info do
      user_agent { "Test User Agent" }
      ip_address { "127.0.0.1" }
    end
  end
end
