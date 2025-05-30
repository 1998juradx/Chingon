class Client < ApplicationRecord

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "name", "phone", "status", "updated_at"]
  end
end
