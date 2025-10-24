class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :location
  belongs_to :listable, polymorphic: true

  validates :title, :purpose, :price, :condition, :status, presence: true

  PURPOSE_TYPES = %w[buy sell].freeze
  CONDITIONS = %w[any mint near_mint excellent good light_played played poor].freeze
  STATUSES = %w[active deactivated completed].freeze

  validates :purpose, inclusion: { in: PURPOSE_TYPES }
  validates :condition, inclusion: { in: CONDITIONS }
  validates :status, inclusion: { in: STATUSES }

  validates :title, presence: true, uniqueness: { scope: [:user_id, :purpose] }
end
