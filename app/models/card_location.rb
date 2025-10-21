class CardLocation < ApplicationRecord
  has_many :listings

  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
  validates :city, presence: true
  validates :state, presence: true
end
