class AddOrderToOrderProducts < ActiveRecord::Migration[7.0]
  def change
    # add_reference :order_products, :order, null: false, foreign_key: true
    puts ">>> Migración 20250528205753: Verificando order_id en order_products. Acción omitida. <<<"
  end
end