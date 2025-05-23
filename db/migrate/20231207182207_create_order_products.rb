class CreateOrderProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :order_products do |t|
      t.references :product, null: true, foreign_key: true
      t.float :price
      t.float :units
      t.float :total
      t.integer :status

      t.timestamps
    end
  end
end
