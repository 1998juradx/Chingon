class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :client, null: true, foreign_key: true
      t.float :total
      t.references :payment_method, null: true, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
