class Expense < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["admin_user_id", "created_at", "description", "id", "invoice", "name", "paid_at", "payment_method_id", "status", "updated_at"]
  end

  belongs_to :admin_user
  belongs_to :payment_method

  mount_uploader :invoice, ImageUploader

  PENDING = 0
  PAID = 1
  VOID = 3

  enum status: { pendiente: PENDING, pagado: PAID, anulado: VOID }
end
