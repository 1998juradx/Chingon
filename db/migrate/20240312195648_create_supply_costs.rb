class CreateSupplyCosts < ActiveRecord::Migration[7.0]
  def change
    create_table :supply_costs do |t|
      t.references :supply, null: true, foreign_key: true
      t.integer :status
      t.float :cost

      t.timestamps
    end
  end
end
