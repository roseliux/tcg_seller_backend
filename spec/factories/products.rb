FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    product_type { :cards }
    rarity { :common }
    association :category

    # Individual card traits
    trait :charizard do
      name { "Charizard" }
      product_type { :cards }
      rarity { :rare }
    end

    trait :pikachu do
      name { "Pikachu" }
      product_type { :cards }
      rarity { :common }
    end

    trait :black_lotus do
      name { "Black Lotus" }
      product_type { :cards }
      rarity { :mythic_rare }
    end

    # Sealed product traits
    trait :booster_pack do
      name { "Booster Pack" }
      product_type { :sealed }
      rarity { nil }
    end

    trait :starter_deck do
      name { "Starter Deck" }
      product_type { :sealed }
      rarity { nil }
    end

    trait :collector_box do
      name { "Elite Trainer Box" }
      product_type { :sealed }
      rarity { nil }
    end

    trait :theme_deck do
      name { "Theme Deck" }
      product_type { :sealed }
      rarity { nil }
    end

    trait :blister_pack do
      name { "Blister Pack" }
      product_type { :sealed }
      rarity { nil }
    end

    # Rarity traits
    trait :common_card do
      rarity { :common }
    end

    trait :uncommon_card do
      rarity { :uncommon }
    end

    trait :rare_card do
      rarity { :rare }
    end

    trait :mythic_rare_card do
      rarity { :mythic_rare }
    end

    trait :secret_rare_card do
      rarity { :secret_rare }
    end
  end
end
