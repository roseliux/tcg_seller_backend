class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :location
  belongs_to :category
  belongs_to :item, polymorphic: true

  validates :title, :purpose, :price, :condition, :status, presence: true

  PURPOSE_TYPES = %w[sell looking].freeze
  CONDITIONS = %w[any mint near_mint excellent good light_played played poor].freeze
  STATUSES = %w[active deactivated completed].freeze

  validates :purpose, inclusion: { in: PURPOSE_TYPES }
  validates :condition, inclusion: { in: CONDITIONS }
  validates :status, inclusion: { in: STATUSES }

  validates :title, presence: true, uniqueness: { scope: [:user_id, :purpose] }

  before_validation :set_default_values, on: :create

  private

  def set_default_values
    self.status ||= "active"
    self.condition ||= "any"
  end
end
