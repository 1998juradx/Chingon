class PaymentMethod < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "status", "updated_at"]
  end
end
