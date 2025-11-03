FactoryBot.define do
  factory :location, aliases: [:card_location] do
    name { "Hermosillo, Sonora" }
    country { "Mexico" }
    city { "Hermosillo" }
    state { "Sonora" }
    postal_code { "83224" }
  end
end
