class Debt < ApplicationRecord
  #belongs_to :admin_user
  #belongs_to :client
  #has_many :payments, dependent: :destroy

  #accepts_nested_attributes_for :payments, allow_destroy: true

  #enum status: { pendiente: 0, pagada: 1, en_mora: 2, refinanciada: 3, cancelada: 4 }

  #validates :client, presence: true
  #validates :admin_user, presence: true
  #validates :installments, presence: true, numericality: { only_integer: true, greater_than: 0 }
  #validates :amount, presence: true, numericality: { greater_than: 0 }
  #validates :quota, presence: true, numericality: { greater_than: 0 }
  #validates :status, presence: true
  #validates :start_at, presence: true

  #def self.ransackable_attributes(auth_object = nil)
    #["amount", "client_id", "created_at", "currency", "due_day", "end_at", "id", "installments", "interest_rate", "quota", "start_at", "status", "token", "updated_at", "admin_user_id"]
  #end

  #def self.ransackable_associations(auth_object = nil)
    #["client", "payments", "admin_user"]
  #end
end