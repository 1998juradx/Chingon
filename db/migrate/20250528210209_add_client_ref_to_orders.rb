# db/migrate/20250528210209_add_client_ref_to_orders.rb
class AddClientRefToOrders < ActiveRecord::Migration[7.0]
  def change
    # La siguiente línea está COMENTADA (con un # al inicio)
    # porque la columna 'client_id' ya existe en tu tabla 'orders'.
    # Si esta línea NO está comentada, el error continuará.

    # add_reference :orders, :client, null: true, foreign_key: true # <--- ¡PONER # AQUÍ!

    # Este mensaje es para confirmar que la migración se "ejecuta" sin hacer la acción de arriba.
    puts ">>> Migración AddClientRefToOrders: Columna client_id ya existe, no se realiza ninguna acción. <<<"
  end
end