class AddIsTacoToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :is_taco, :boolean
  end
end
