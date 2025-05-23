class AddOrderToOrderProduct < ActiveRecord::Migration[7.0]
  def change
    add_reference :order_products, :order, null: true, foreign_key: true
  end
end
