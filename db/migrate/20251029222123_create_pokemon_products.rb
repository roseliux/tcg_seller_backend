class CreatePokemonProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :pokemon_products do |t|
      t.string :name, null: false
      t.text :description
      t.string :product_type, null: false # sealed, bulk, deck
      t.string :card_set_id # optional - for set-specific products
      t.string :language, default: 'english'
      t.jsonb :metadata, default: {} # flexible storage for type-specific data

      t.timestamps
    end

    add_index :pokemon_products, :product_type
    add_index :pokemon_products, :card_set_id
    add_index :pokemon_products, :name
    add_foreign_key :pokemon_products, :card_sets, column: :card_set_id, on_delete: :nullify
  end
end
