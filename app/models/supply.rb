class Supply < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "status", "unit", "updated_at"]
  end

  has_many :supply_inventories, dependent: :destroy

  has_many :product_supplies, dependent: :destroy
  has_many :products, through: :product_supplies
end
