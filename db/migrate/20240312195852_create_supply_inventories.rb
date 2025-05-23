class CreateSupplyInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :supply_inventories do |t|
      t.references :supply, null: true, foreign_key: true
      t.integer :operation
      t.float :units
      t.integer :status

      t.timestamps
    end
  end
end
