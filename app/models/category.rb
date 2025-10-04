class Category < ApplicationRecord
  belongs_to :card_set
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :release_date, presence: true
end
