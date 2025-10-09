require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:category) { create(:category, :pokemon) }
  let(:card_set) { create(:card_set, id: "base1", name: "Base Set", category: category) }

  describe "validations" do
    subject { build(:card, id: "base1-1", name: "Alakazam", card_set: card_set, category: category) }

    it { should validate_uniqueness_of(:id) }
    it { should validate_presence_of(:name) }

    it "validates presence of id for existing records" do
      card = create(:card, id: "test-1", name: "Test Card", card_set: card_set, category: category)
      card.id = ""
      expect(card).not_to be_valid
      expect(card.errors[:id]).to include("can't be blank")
    end

    it "validates presence of name" do
      card = build(:card, name: "", card_set: card_set, category: category)
      expect(card).not_to be_valid
      expect(card.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    it { should belong_to(:card_set) }
    it { should belong_to(:category) }

    it "correctly associates with card_set using string primary key" do
      card = create(:card, id: "base1-1", card_set: card_set, category: category)
      expect(card.card_set).to eq(card_set)
      expect(card.card_set_id).to eq("base1")
    end

    it "correctly associates with category using string primary key" do
      card = create(:card, id: "base1-1", card_set: card_set, category: category)
      expect(card.category).to eq(category)
      expect(card.category_id).to eq("pokemon")
    end
  end

  describe "string primary key" do
    it "uses string as primary key" do
      expect(Card.primary_key).to eq("id")
    end

    it "allows custom string IDs like Pokemon TCG format" do
      card = create(:card, id: "base1-1", name: "Alakazam", card_set: card_set, category: category)
      expect(card.id).to eq("base1-1")
      expect(card.persisted?).to be true
    end

    it "generates UUID if no ID provided during creation" do
      card = Card.new(name: "Test Card", card_set: card_set, category: category)
      expect(card.id).to be_blank

      card.save!

      expect(card.id).to be_present
      expect(card.id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end

  describe "factory" do
    it "creates valid card with associations" do
      card = build(:card, card_set: card_set, category: category)
      expect(card).to be_valid
    end

    it "creates card with Pokemon TCG style ID" do
      card = create(:card, id: "base1-4", name: "Charizard", card_set: card_set, category: category)

      expect(card.id).to eq("base1-4")
      expect(card.name).to eq("Charizard")
      expect(card.card_set.id).to eq("base1")
      expect(card.category.id).to eq("pokemon")
    end
  end

  describe "database constraints" do
    it "prevents duplicate IDs" do
      create(:card, id: "base1-1", card_set: card_set, category: category)

      duplicate_card = build(:card, id: "base1-1", card_set: card_set, category: category)
      expect(duplicate_card).not_to be_valid
      expect(duplicate_card.errors[:id]).to include("has already been taken")
    end

    it "requires card_set association" do
      card = build(:card, card_set: nil, category: category)
      expect(card).not_to be_valid
      expect(card.errors[:card_set]).to be_present
    end

    it "requires category association" do
      card = build(:card, card_set: card_set, category: nil)
      expect(card).not_to be_valid
      expect(card.errors[:category]).to be_present
    end
  end

  describe "real-world scenarios" do
    it "creates Pokemon Base Set cards correctly" do
      alakazam = create(:card,
        id: "base1-1",
        name: "Alakazam",
        card_set: card_set,
        category: category
      )

      charizard = create(:card,
        id: "base1-4",
        name: "Charizard",
        card_set: card_set,
        category: category
      )

      expect(alakazam.id).to eq("base1-1")
      expect(charizard.id).to eq("base1-4")
      expect([alakazam, charizard].map(&:card_set)).to all(eq(card_set))
      expect([alakazam, charizard].map(&:category)).to all(eq(category))
    end

    it "handles cards from different sets" do
      jungle_set = create(:card_set, id: "jungle", name: "Jungle", category: category)

      base_card = create(:card, id: "base1-1", name: "Alakazam", card_set: card_set, category: category)
      jungle_card = create(:card, id: "jungle-1", name: "Clefable", card_set: jungle_set, category: category)

      expect(base_card.card_set.name).to eq("Base Set")
      expect(jungle_card.card_set.name).to eq("Jungle")
      expect([base_card, jungle_card].map(&:category)).to all(eq(category))
    end

    it "supports different TCG categories" do
      magic_category = create(:category, :magic)
      magic_set = create(:card_set, id: "beta", name: "Beta Edition", category: magic_category)

      pokemon_card = create(:card, id: "base1-1", name: "Alakazam", card_set: card_set, category: category)
      magic_card = create(:card, id: "beta-1", name: "Black Lotus", card_set: magic_set, category: magic_category)

      expect(pokemon_card.category.name).to eq("Pokemon")
      expect(magic_card.category.name).to eq("Magic: The Gathering")
    end
  end
end
