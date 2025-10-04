require 'rails_helper'

RSpec.describe CardSet, type: :model do
  subject { build(:card_set) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:products).through(:categories) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:card_set)).to be_valid
    end

    it 'creates valid traits' do
      expect(build(:card_set, :pokemon_base_set)).to be_valid
      expect(build(:card_set, :magic_alpha)).to be_valid
      expect(build(:card_set, :yugioh_legend_of_blue_eyes)).to be_valid
    end
  end

  describe 'validations in detail' do
    context 'when name is missing' do
      it 'is invalid' do
        card_set = build(:card_set, name: nil)
        expect(card_set).not_to be_valid
        expect(card_set.errors[:name]).to include("can't be blank")
      end
    end

    context 'when name is duplicate' do
      it 'is invalid' do
        create(:card_set, name: "Pokemon Base Set")
        duplicate_set = build(:card_set, name: "Pokemon Base Set")
        expect(duplicate_set).not_to be_valid
        expect(duplicate_set.errors[:name]).to include("has already been taken")
      end
    end

    context 'when name is unique' do
      it 'is valid' do
        card_set = build(:card_set, name: "Unique Set Name")
        expect(card_set).to be_valid
      end
    end
  end
end
