class AddCategoryIdToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :category_id, :string, null: false

    add_foreign_key :listings, :categories, column: :category_id, primary_key: :id
  end
end
