require 'rails_helper'

RSpec.describe CardSet, type: :model do
  subject { build(:card_set) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:card_set)).to be_valid
    end

    it 'creates valid traits' do
      expect(build(:card_set, :base_set_unlimited)).to be_valid
      expect(build(:card_set, :first_edition)).to be_valid
      expect(build(:card_set, :magic_beta)).to be_valid
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
  end
end
