class CreateProductSupplies < ActiveRecord::Migration[7.0]
  def change
    create_table :product_supplies do |t|
      t.references :product, null: true, foreign_key: true
      t.references :supply, null: true, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
