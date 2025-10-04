require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build(:category) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:release_date) }
  end

  describe 'associations' do
    it { should belong_to(:card_set) }
    it { should have_many(:products).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:category)).to be_valid
    end

    it 'creates valid traits' do
      expect(build(:category, :base_set_unlimited)).to be_valid
      expect(build(:category, :base_set_shadowless)).to be_valid
      expect(build(:category, :first_edition)).to be_valid
      expect(build(:category, :magic_beta)).to be_valid
    end
  end

  describe 'validations in detail' do
    let(:card_set) { create(:card_set) }

    context 'when name is missing' do
      it 'is invalid' do
        category = build(:category, name: nil, card_set: card_set)
        expect(category).not_to be_valid
        expect(category.errors[:name]).to include("can't be blank")
      end
    end

    context 'when release_date is missing' do
      it 'is invalid' do
        category = build(:category, release_date: nil, card_set: card_set)
        expect(category).not_to be_valid
        expect(category.errors[:release_date]).to include("can't be blank")
      end
    end

    context 'when card_set is missing' do
      it 'is invalid' do
        category = build(:category, card_set: nil)
        expect(category).not_to be_valid
        expect(category.errors[:card_set]).to include("must exist")
      end
    end

    context 'when all required fields are present' do
      it 'is valid' do
        category = build(:category,
          name: "Valid Category",
          release_date: Date.current,
          card_set: card_set
        )
        expect(category).to be_valid
      end
    end

    context 'when release_date is in the future' do
      it 'is valid' do
        category = build(:category,
          release_date: 1.year.from_now,
          card_set: card_set
        )
        expect(category).to be_valid
      end
    end

    context 'when release_date is in the past' do
      it 'is valid' do
        category = build(:category,
          release_date: 10.years.ago,
          card_set: card_set
        )
        expect(category).to be_valid
      end
    end
  end
end
