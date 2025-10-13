class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :card_set

  LISTING_TYPES = %w[selling looking].freeze
  CONDITIONS = %w[any mint near_mint excellent good light_played played poor].freeze
  STATUSES = %w[active deactivated sold found].freeze

  validates :listing_type, inclusion: { in: LISTING_TYPES }
  validates :condition, inclusion: { in: CONDITIONS }
  validates :status, inclusion: { in: STATUSES }

  validates :item_title, presence: true, uniqueness: { scope: [:user_id, :listing_type] }
end
