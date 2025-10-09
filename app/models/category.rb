class Category < ApplicationRecord
  self.primary_key = :id

  has_many :card_sets, dependent: :destroy
  has_many :cards, dependent: :destroy

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  before_validation :ensure_id_present, on: :create

  private

  def ensure_id_present
    if id.blank? && name.present?
      # Generate a readable id from the name (slugified, lowercased, hyphens)
      self.id = name.parameterize(separator: "-")
    end
  end
end
