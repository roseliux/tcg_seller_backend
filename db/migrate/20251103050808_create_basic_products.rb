class CreateBasicProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :basic_products do |t|
      t.string :name, null: false
      t.text :description
      t.string :product_type, null: false # sealed, bulk, deck
      t.jsonb :metadata, default: {} # flexible storage for type-specific data

      t.timestamps
    end
  end
end
