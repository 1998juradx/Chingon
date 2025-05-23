class AddCostToSupplyInventory < ActiveRecord::Migration[7.0]
  def change
    add_column :supply_inventories, :cost, :float
  end
end
