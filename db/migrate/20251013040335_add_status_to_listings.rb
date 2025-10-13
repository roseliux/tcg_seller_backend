class AddStatusToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :status, :string, default: 'active', null: false
  end
end
