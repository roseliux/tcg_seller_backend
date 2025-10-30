class RenameListableToItemInListings < ActiveRecord::Migration[8.0]
  def change
    rename_column :listings, :listable_type, :item_type
    rename_column :listings, :listable_id, :item_id

    # Add indexes for polymorphic association (if they don't exist)
    # These are critical for query performance on polymorphic lookups
    add_index :listings, [:item_type, :item_id], if_not_exists: true
    add_index :listings, :item_type, if_not_exists: true
    add_index :listings, :item_id, if_not_exists: true
  end
end
