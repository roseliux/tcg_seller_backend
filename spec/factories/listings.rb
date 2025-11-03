FactoryBot.define do
  factory :listing do
    sequence(:title) { |n| "Charizard VMAX - Mint Condition #{n}" }
    description { "Perfect condition, pulled from pack" }
    price { 99.99 }
    purpose { "sell" }
    condition { "mint" }
    status { "active" }

    association :user
    association :location

    # Polymorphic association - defaults to pokemon_product
    association :item, factory: :pokemon_product

    trait :looking do
      purpose { "looking" }
      sequence(:title) { |n| "Looking for Charizard VMAX #{n}" }
    end

    trait :deactivated do
      status { "deactivated" }
    end

    trait :completed do
      status { "completed" }
    end

    trait :with_card do
      association :item, factory: :pokemon_product
    end
  end
end
