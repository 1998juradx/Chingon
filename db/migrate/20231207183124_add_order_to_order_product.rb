# db/migrate/20250528205753_add_order_to_order_products.rb
class AddOrderToOrderProducts < ActiveRecord::Migration[7.0]
  def change
    # La siguiente línea DEBE estar comentada (con un # al inicio)
    # porque la columna order_id ya debería existir en tu tabla order_products.
    # Si esta línea NO está comentada, el error de "columna ya definida" volverá.

    # add_reference :order_products, :order, null: false, foreign_key: true # <--- ASEGÚRATE QUE ESTÉ COMENTADA ASÍ

    # Este mensaje es para confirmar que la migración se "ejecuta" sin hacer la acción de arriba.
    puts ">>> Migración AddOrderToOrderProducts: Verificando order_id. Si ya existe, no se hace nada. <<<"
  end
end