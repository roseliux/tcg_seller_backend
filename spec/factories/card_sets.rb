FactoryBot.define do
  factory :card_set do
    sequence(:name) { |n| "Card Set #{n}" }

    trait :pokemon_base_set do
      name { "Pokemon Base Set" }
    end

    trait :magic_alpha do
      name { "Magic: The Gathering Alpha" }
    end

    trait :yugioh_legend_of_blue_eyes do
      name { "Yu-Gi-Oh! Legend of Blue Eyes White Dragon" }
    end
  end
end
