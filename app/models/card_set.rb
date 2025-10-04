class CardSet < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :products, through: :categories

  validates :name, presence: true, uniqueness: true
end
