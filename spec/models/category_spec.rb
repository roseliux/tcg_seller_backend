require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build(:category) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:card_sets).dependent(:destroy) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:category)).to be_valid
    end

    it 'creates valid traits' do
      expect(build(:category, :pokemon)).to be_valid
      expect(build(:category, :magic)).to be_valid
      expect(build(:category, :yugioh)).to be_valid
    end
  end

  describe 'validations in detail' do
    let(:card_set) { create(:card_set) }

    context 'when name is missing' do
      it 'is invalid' do
        category = build(:category, name: nil)
        expect(category).not_to be_valid
        expect(category.errors[:name]).to include("can't be blank")
      end
    end

    context 'when all required fields are present' do
      it 'is valid' do
        category = build(:category,
          name: "Valid Category"
        )
        expect(category).to be_valid
      end
    end
  end
end
