class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards, id: false do |t|
      t.string :id, primary_key: true
      t.string :name
      t.string :card_set_id, null: false
      t.string :category_id, null: false

      t.timestamps
    end

    add_foreign_key :cards, :card_sets, column: :card_set_id, primary_key: :id
    add_foreign_key :cards, :categories, column: :category_id, primary_key: :id
  end
end
