class AddClientNameToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :client_name, :string
  end
end
