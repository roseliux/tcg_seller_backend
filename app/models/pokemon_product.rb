class PokemonProduct < ApplicationRecord
  # Polymorphic association for listings
  # has_many :listings, as: :listable, dependent: :destroy
  has_many :listings, as: :listable, dependent: :restrict_with_error # Raises error and prevents deletion if listings exist

  # Optional association to card set
  belongs_to :card_set, optional: true

  # Product type enum
  enum :product_type, {
    card: "card",
    # Sealed products
    booster_pack: "booster_pack",
    booster_box: "booster_box",
    elite_trainer_box: "elite_trainer_box",
    collection_box: "collection_box",
    starter_deck: "starter_deck",
    theme_deck: "theme_deck",
    bundle: "bundle",
    blister_pack: "blister_pack",
    tin: "tin",

    # Bulk products
    bulk: "bulk",
    # bulk_commons: 'bulk_commons',
    # bulk_uncommons: 'bulk_uncommons',
    # bulk_rares: 'bulk_rares',
    # bulk_holos: 'bulk_holos',
    # bulk_mixed: 'bulk_mixed',

    # Deck products
    deck: "deck",
    # custom_deck: 'custom_deck',
    # precon_deck: 'precon_deck',

    # Other
    other: "other"
  }, prefix: true

  # Validations
  validates :name, presence: true
  validates :product_type, presence: true

  # Custom validations
  # validate :sealed_should_have_card_set

  # Scopes
  scope :sealed_products, -> { where(product_type: %w[booster_pack booster_box elite_trainer_box collection_box starter_deck theme_deck bundle tin]) }
  scope :bulk_products, -> { where(product_type: %w[bulk bulk_commons bulk_uncommons bulk_rares bulk_holos bulk_mixed]) }
  scope :deck_products, -> { where(product_type: %w[deck custom_deck precon_deck]) }
  scope :by_set, ->(set_id) { where(card_set_id: set_id) }

  # Helper methods
  def sealed?
    product_type.in?(%w[booster_pack booster_box elite_trainer_box collection_box starter_deck theme_deck bundle tin])
  end

  def bulk?
    product_type.in?(%w[bulk_commons bulk_uncommons bulk_rares bulk_holos bulk_mixed])
  end

  def deck?
    product_type.in?(%w[custom_deck precon_deck])
  end

  private

  def sealed_should_have_card_set
    return unless sealed?
    return if card_set.present?

    errors.add(:card_set, "is recommended for sealed products")
  end
end
