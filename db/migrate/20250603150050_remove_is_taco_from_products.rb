class RemoveIsTacoFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :is_taco, :boolean
  end
end