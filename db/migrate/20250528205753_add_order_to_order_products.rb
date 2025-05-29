# db/migrate/20250528205753_add_order_to_order_products.rb
class AddOrderToOrderProducts < ActiveRecord::Migration[7.0]
  def change
    # La siguiente línea está COMENTADA (con un # al inicio)
    # porque la columna 'order_id' ya existe en tu tabla 'order_products'.
    # Si esta línea NO está comentada, el error continuará.

    # add_reference :order_products, :order, null: false, foreign_key: true

    # Este mensaje es para que sepas que la migración se "ejecutó" sin problemas.
    puts ">>> Migración AddOrderToOrderProducts: Columna order_id ya existe, no se realiza ninguna acción. <<<"
  end
end