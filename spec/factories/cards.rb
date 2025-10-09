FactoryBot.define do
  factory :card do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Card #{n}" }
    association :card_set
    association :category

    trait :pokemon_base_alakazam do
      id { "base1-1" }
      name { "Alakazam" }
    end

    trait :pokemon_base_charizard do
      id { "base1-4" }
      name { "Charizard" }
    end

    trait :pokemon_jungle_clefable do
      id { "jungle-1" }
      name { "Clefable" }
    end

    trait :magic_beta_black_lotus do
      id { "beta-1" }
      name { "Black Lotus" }
    end
  end
end
