class BasicProduct < ApplicationRecord
  # Polymorphic association for listings
  has_many :listings, as: :item, dependent: :restrict_with_error # Raises error and prevents deletion if listings exist

  # Product type enum
  enum :product_type, {
    card: "card",
    sealed: "sealed",
    bulk: "bulk",
    deck: "deck",
    accessory: "accessory",
    other: "other"
  }, prefix: true

  # Validations
  validates :name, presence: true
  validates :product_type, presence: true
end
