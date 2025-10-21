class AddCardLocationToListings < ActiveRecord::Migration[8.0]
  def change
    add_reference :listings, :card_location, null: false, foreign_key: true
  end
end
