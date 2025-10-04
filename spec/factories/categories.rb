FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    release_date { 1.year.ago }
    association :card_set

    trait :base_set_unlimited do
      name { "Base Set Unlimited" }
      release_date { Date.parse("1999-01-09") }
    end

    trait :base_set_shadowless do
      name { "Base Set Shadowless" }
      release_date { Date.parse("1999-01-09") }
    end

    trait :first_edition do
      name { "Base Set 1st Edition" }
      release_date { Date.parse("1998-10-20") }
    end

    trait :magic_beta do
      name { "Beta Edition" }
      release_date { Date.parse("1993-10-01") }
    end
  end
end
