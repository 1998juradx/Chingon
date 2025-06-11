# db/migrate/20250610234918_add_admin_user_to_debts.rb
class AddAdminUserToDebts < ActiveRecord::Migration[7.0]
  def change
    # Añadimos la columna 'admin_user_id' directamente, sin crear la llave foránea automáticamente.
    add_column :debts, :admin_user_id, :integer
    
    # Luego, añadimos el índice para que las búsquedas sean rápidas.
    add_index :debts, :admin_user_id
    
    # La opción de 'foreign_key: true' automática es la que está buscando la tabla 'users'.
    # Al hacerlo en dos pasos, evitamos esa convención automática y el error.
    # Si necesitas la restricción de llave foránea a nivel de base de datos,
    # la línea sería: add_foreign_key :debts, :admin_users
  end
end