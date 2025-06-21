# db/migrate/[timestamp]_add_provider_ref_to_expenses.rb
class AddProviderRefToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_reference :expenses, :provider, null: true, foreign_key: true # null: true hace que sea opcional
  end
end