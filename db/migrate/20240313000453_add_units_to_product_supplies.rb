class AddUnitsToProductSupplies < ActiveRecord::Migration[7.0]
  def change
    add_column :product_supplies, :units, :float
  end
end
