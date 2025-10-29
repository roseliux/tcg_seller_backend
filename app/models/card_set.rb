class CardSet < ApplicationRecord
  self.primary_key = :id

  belongs_to :category, primary_key: :id
  has_many :cards, dependent: :destroy
  has_many :pokemon_products, dependent: :nullify

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true

  before_validation :ensure_id_present, on: :create

  private

  def ensure_id_present
    self.id = SecureRandom.uuid if id.blank?
  end
end
