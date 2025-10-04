require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:product_type) }
    # Note: rarity is optional, so no presence validation
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_one(:card_set).through(:category) }
  end

  describe 'enums' do
    it 'defines rarity enum' do
      expect(Product.rarities.keys).to contain_exactly(
        'common', 'uncommon', 'rare', 'mythic_rare',
        'legendary', 'ultra_rare', 'secret_rare'
      )
    end

    it 'defines product_type enum' do
      expect(Product.product_types.keys).to contain_exactly(
        'cards', 'sealed'
      )
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:product)).to be_valid
    end

    it 'creates valid card traits' do
      expect(build(:product, :charizard)).to be_valid
      expect(build(:product, :pikachu)).to be_valid
      expect(build(:product, :black_lotus)).to be_valid
    end

    it 'creates valid sealed product traits' do
      expect(build(:product, :booster_pack)).to be_valid
      expect(build(:product, :starter_deck)).to be_valid
      expect(build(:product, :collector_box)).to be_valid
      expect(build(:product, :theme_deck)).to be_valid
      expect(build(:product, :blister_pack)).to be_valid
    end
  end

  describe 'validations in detail' do
    let(:category) { create(:category) }

    context 'when name is missing' do
      it 'is invalid' do
        product = build(:product, name: nil, category: category)
        expect(product).not_to be_valid
        expect(product.errors[:name]).to include("can't be blank")
      end
    end

    context 'when product_type is missing' do
      it 'is invalid' do
        product = build(:product, product_type: nil, category: category)
        expect(product).not_to be_valid
        expect(product.errors[:product_type]).to include("can't be blank")
      end
    end

    context 'when category is missing' do
      it 'is invalid' do
        product = build(:product, category: nil)
        expect(product).not_to be_valid
        expect(product.errors[:category]).to include("must exist")
      end
    end

    context 'when rarity is nil' do
      it 'is valid for sealed products' do
        product = build(:product,
          name: "Booster Pack",
          product_type: :sealed,
          rarity: nil,
          category: category
        )
        expect(product).to be_valid
      end
    end

    context 'when all required fields are present' do
      it 'is valid' do
        product = build(:product,
          name: "Valid Product",
          product_type: :cards,
          rarity: :common,
          category: category
        )
        expect(product).to be_valid
      end
    end
  end

  describe 'enum behavior' do
    let(:category) { create(:category) }

    context 'rarity enum' do
      it 'accepts valid rarity values' do
        product = build(:product, rarity: :rare, category: category)
        expect(product).to be_valid
        expect(product.rare?).to be true
      end

      it 'accepts nil rarity' do
        product = build(:product, rarity: nil, category: category)
        expect(product).to be_valid
        expect(product.rarity).to be_nil
      end

      it 'provides rarity query methods' do
        common_product = create(:product, :common_card, category: category)
        rare_product = create(:product, :rare_card, category: category)

        expect(common_product.common?).to be true
        expect(common_product.rare?).to be false
        expect(rare_product.rare?).to be true
        expect(rare_product.common?).to be false
      end
    end

    context 'product_type enum' do
      it 'accepts valid product_type values' do
        product = build(:product, product_type: :sealed, category: category)
        expect(product).to be_valid
        expect(product.sealed?).to be true
      end

      it 'provides product_type query methods' do
        card = create(:product, product_type: :cards, category: category)
        sealed = create(:product, product_type: :sealed, category: category)

        expect(card.cards?).to be true
        expect(card.sealed?).to be false
        expect(sealed.sealed?).to be true
        expect(sealed.cards?).to be false
      end
    end
  end

  describe 'relationships' do
    it 'can access card_set through category' do
      card_set = create(:card_set, name: "Test Set")
      category = create(:category, card_set: card_set)
      product = create(:product, category: category)

      expect(product.card_set).to eq(card_set)
      expect(product.card_set.name).to eq("Test Set")
    end
  end
end
