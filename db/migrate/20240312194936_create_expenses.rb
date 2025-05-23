class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.string :description
      t.references :admin_user, null: true, foreign_key: true
      t.references :payment_method, null: true, foreign_key: true
      t.date :paid_at
      t.string :invoice
      t.integer :status

      t.timestamps
    end
  end
end
