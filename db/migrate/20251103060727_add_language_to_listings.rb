class AddLanguageToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :language, :string, null: false, default: "english"
  end
end
