class AddAdminUserToPayments < ActiveRecord::Migration[7.0]
  def change
    # Añadimos la columna 'admin_user_id' y el índice por separado
    # para evitar que Rails busque la tabla 'users' por convención.
    add_column :payments, :admin_user_id, :integer
    add_index :payments, :admin_user_id
  end
end