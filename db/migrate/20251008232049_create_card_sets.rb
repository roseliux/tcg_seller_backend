class CreateCardSets < ActiveRecord::Migration[8.0]
  def change
    create_table :card_sets, id: false do |t|
      t.string :id, primary_key: true
      t.string :name
      t.date :release_date
      t.string :category_id, null: false

      t.timestamps
    end

    add_foreign_key :card_sets, :categories, column: :category_id, primary_key: :id
  end
end
