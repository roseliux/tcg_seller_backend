class AddNameIndexToCards < ActiveRecord::Migration[8.0]
  def change
    # Add index for case-insensitive name searches
    add_index :cards, "LOWER(name)", name: 'index_cards_on_lower_name'

    # Also add regular name index for ordering
    add_index :cards, :name
  end
end
