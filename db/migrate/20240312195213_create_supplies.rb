class CreateSupplies < ActiveRecord::Migration[7.0]
  def change
    create_table :supplies do |t|
      t.string :name
      t.string :unit
      t.integer :status

      t.timestamps
    end
  end
end
