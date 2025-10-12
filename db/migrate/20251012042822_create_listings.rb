class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :item_title
      t.text :description
      t.string :price
      t.string :listing_type
      t.string :condition
      t.bigint :user_id, null: false           # matches users.id
      t.string :category_id, null: false
      t.string :card_set_id, null: false
      t.timestamps
    end

    # Add foreign keys manually
    add_foreign_key :listings, :users, column: :user_id, primary_key: :id
    add_foreign_key :listings, :categories, column: :category_id, primary_key: :id
    add_foreign_key :listings, :card_sets, column: :card_set_id, primary_key: :id
    # Add index for uniqueness constraint
    add_index :listings, [:item_title, :user_id, :listing_type], unique: true
  end
end
