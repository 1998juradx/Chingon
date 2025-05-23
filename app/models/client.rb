class Client < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "name", "phone", "status", "updated_at"]
  end
end
