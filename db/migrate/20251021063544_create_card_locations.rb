class CreateCardLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :card_locations do |t|
      t.string :name, null: false
      t.string :country
      t.string :city
      t.string :state
      t.string :postal_code

      t.timestamps
    end
  end
end
