class Product < ApplicationRecord
  belongs_to :category
  has_one :card_set, through: :category

  validates :name, presence: true
  validates :product_type, presence: true
  # rarity is optional - not all products have rarity (e.g., booster packs, accessories)

  # Enum for common card rarities
  enum :rarity, {
    common: "common",
    uncommon: "uncommon",
    rare: "rare",
    mythic_rare: "mythic_rare",
    legendary: "legendary",
    ultra_rare: "ultra_rare",
    secret_rare: "secret_rare"
  }, allow_nil: true

  # Enum for product types - simplified to two main categories
  enum :product_type, {
    cards: "cards",
    sealed: "sealed"
  }
end
