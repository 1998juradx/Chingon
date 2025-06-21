class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :debt, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.decimal :min_amount
      t.datetime :due_at
      t.string :currency
      t.integer :installment
      t.float :discount
      t.integer :status
      t.decimal :interest_amount
      t.decimal :paid_amount
      t.datetime :discounted_at
      t.datetime :paid_at
      t.decimal :default_interest_amount
      t.decimal :paid_interest_amount
      t.decimal :paid_default_interest_amount

      t.timestamps
    end
  end
end
