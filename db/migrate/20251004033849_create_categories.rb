class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.date :release_date
      t.references :card_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
