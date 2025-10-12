FactoryBot.define do
  factory :listing do
    item_title { "MyString" }
    description { "MyText" }
    price { "9.99" }
    listing_type { "MyString" }
    condition { "MyString" }
    user { nil }
    category { nil }
    card_set { nil }
  end
end
