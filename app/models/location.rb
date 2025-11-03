class Location < ApplicationRecord
  has_many :listings

  # validates :name, presence: true, uniqueness: true
  # validates :country, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  validates :postal_code, presence: true, uniqueness: true, length: { maximum: 5 }, format: { with: /\A\d{5}\z/, message: "must be a valid 5-digit postal code" }

  before_validation :ensure_name_present, on: :create

  private

  def ensure_name_present
    if name.blank? && postal_code.present?
      # Generate a default name based on postal code
      self.name = "Location #{postal_code}"
    end
  end
end
