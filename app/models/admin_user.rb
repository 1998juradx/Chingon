class AdminUser < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "name", "phone", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  has_many :expenses, dependent: :destroy
end
