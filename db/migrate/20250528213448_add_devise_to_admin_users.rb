# db/migrate/20250528213448_add_devise_to_admin_users.rb
# frozen_string_literal: true

class AddDeviseToAdminUsers < ActiveRecord::Migration[7.0]
  def self.up
    # Comentamos todo dentro de change_table porque estas columnas
    # ya deberían existir de la migración original de Devise para AdminUser.
    # change_table :admin_users do |t|
    #   ## Database authenticatable
    #   # t.string :email,              null: false, default: "" # YA EXISTE
    #   # t.string :encrypted_password, null: false, default: "" # YA EXISTE

    #   ## Recoverable
    #   # t.string   :reset_password_token
    #   # t.datetime :reset_password_sent_at

    #   ## Rememberable
    #   # t.datetime :remember_created_at

    #   ## Trackable
    #   # t.integer  :sign_in_count, default: 0, null: false
    #   # t.datetime :current_sign_in_at
    #   # t.datetime :last_sign_in_at
    #   # t.string   :current_sign_in_ip
    #   # t.string   :last_sign_in_ip

    #   ## Confirmable
    #   # t.string   :confirmation_token
    #   # t.datetime :confirmed_at
    #   # t.datetime :confirmation_sent_at
    #   # t.string   :unconfirmed_email # Only if using reconfirmable

    #   ## Lockable
    #   # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
    #   # t.string   :unlock_token # Only if unlock strategy is :email or :both
    #   # t.datetime :locked_at

    #   # Uncomment below if timestamps were not included in your original model.
    #   # t.timestamps null: false
    # end

    # También comentamos los add_index porque ya deberían existir.
    # add_index :admin_users, :email,                unique: true # YA EXISTE
    # add_index :admin_users, :reset_password_token, unique: true
    # # add_index :admin_users, :confirmation_token,   unique: true
    # # add_index :admin_users, :unlock_token,         unique: true

    # Mensaje para confirmar que esta migración se "ejecutó" sin hacer cambios.
    puts ">>> Migración AddDeviseToAdminUsers: Se omiten cambios porque las columnas/índices de Devise ya deberían existir. <<<"
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
