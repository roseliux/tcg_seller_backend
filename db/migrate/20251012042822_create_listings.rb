class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.text :description
      t.string :listable_type, null: false
      t.string :listable_id, null: false
      t.string :purpose, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :condition, null: false
      t.string :status, default: 'active', null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
