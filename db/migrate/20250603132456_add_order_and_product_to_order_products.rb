class AddOrderAndProductToOrderProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :order_products, :order, null: false, foreign_key: true
    # NO AGREGUES product_id porque ya existe
  end
end
