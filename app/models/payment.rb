class Payment < ApplicationRecord

  belongs_to :debt
  belongs_to :cliente
  belongs_to :usuario

  enum status: { aplicado: 0, pendiente: 1, rebotado: 2, anulado: 3 }

  validates :debt, presence: true
  validates :cliente, presence: true
  validates :usuario, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :status, presence: true
  validates :installment, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :min_amount, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :interest_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :paid_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :default_interest_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :paid_interest_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :paid_default_interest_amount, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "client_id", "created_at", "currency", "debt_id", "default_interest_amount", "discount", "discounted_at", "due_at", "id", "installment", "interest_amount", "min_amount", "paid_amount", "paid_at", "paid_default_interest_amount", "paid_interest_amount", "payment_date", "receipt_number", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["cliente", "debt", "usuario"]
  end
end