class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, id: false do |t|
      t.string :id, primary_key: true
      t.string :name

      t.timestamps
    end
  end
end
