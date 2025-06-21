class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :name         # Nombre del gasto
      t.string :description  # Descripción
      t.references :admin_user, null: true, foreign_key: true # Quién registró el gasto
      t.references :payment_method, null: true, foreign_key: true # Cómo se pagó
      t.date :paid_at        # Fecha de pago
      t.string :invoice      # Número de factura o recibo
      t.integer :status       # Estado del gasto (ej. pendiente, pagado)
      t.timestamps
    end
  end
end