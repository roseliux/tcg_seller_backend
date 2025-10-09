FactoryBot.define do
  factory :category do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Category #{n}" }

    trait :pokemon do
      id { "pokemon" }
      name { "Pokemon" }
    end

    trait :magic do
      id { "magic" }
      name { "Magic: The Gathering" }
    end

    trait :yugioh do
      id { "yugioh" }
      name { "Yu-Gi-Oh!" }
    end
  end
end
