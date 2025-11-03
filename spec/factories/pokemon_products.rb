FactoryBot.define do
  factory :pokemon_product do
    name { "Charizard ex" }
    product_type { "card" }
    language { "english" }
    description { "A powerful Pokemon card" }

    association :card_set

    trait :sealed do
      product_type { "booster_box" }
      name { "Base Set Booster Box" }
    end

    trait :bulk do
      product_type { "bulk" }
      name { "Mixed Pokemon Bulk" }
    end

    trait :deck do
      product_type { "deck" }
      name { "Charizard Competitive Deck" }
      metadata { { format: "standard", strategy: "aggro" } }
    end
  end
end
