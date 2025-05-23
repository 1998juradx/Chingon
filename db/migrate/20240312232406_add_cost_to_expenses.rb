class AddCostToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :cost, :float
  end
end
