class CreateDebts < ActiveRecord::Migration[7.0]
  def change
    create_table :debts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.integer :installments
      t.integer :due_day
      t.date :start_at
      t.date :end_at
      t.float :interest_rate
      t.decimal :amount
      t.decimal :quota
      t.string :currency
      t.string :token
      t.integer :status

      t.timestamps
    end
  end
end
