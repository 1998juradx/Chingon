class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :address

      t.timestamps
    end
  end
end
