class Expense < ApplicationRecord
  belongs_to :admin_user
  belongs_to :payment_method
  belongs_to :provider, optional: true # AÑADIDO: Asociación con Provider (opcional)

  mount_uploader :invoice, ImageUploader # Para CarrierWave

  PENDING = 0
  PAID = 1
  VOID = 3 # Tu enum salta el 2, lo cual está bien.

  enum status: { pendiente: PENDING, pagado: PAID, anulado: VOID }

  validates :name,
            presence: { message: "El nombre/concepto del gasto no puede estar en blanco." },
            length: { minimum: 3, maximum: 150,
                      too_short: "El nombre/concepto debe tener al menos %{count} caracteres.",
                      too_long: "El nombre/concepto no puede tener más de %{count} caracteres." }

  validates :description,
            length: { maximum: 500,
                      too_long: "La descripción no puede tener más de %{count} caracteres." },
            allow_blank: true # La descripción puede ser opcional

  validates :amount, # Asumiendo que ya añadiste esta columna a tu tabla 'expenses'
            presence: { message: "El monto del gasto no puede estar en blanco." },
            numericality: {
              greater_than: 0,
              message: "El monto del gasto debe ser un número mayor que cero."
            }

  validates :status,
            presence: { message: "Debe seleccionar un estado para el gasto." }
            # El enum ya valida que el valor sea uno de los permitidos.

  validates :admin_user, presence: { message: "El gasto debe ser registrado por un administrador." }
  validates :payment_method, presence: { message: "Debe seleccionar un método de pago para el gasto." }

  # Si 'paid_at' es la fecha en que se pagó, probablemente debería ser obligatoria si el status es 'pagado'
  validates :paid_at, presence: { message: "La fecha de pago no puede estar en blanco." }, if: :pagado?
  # Si 'expense_date' es la fecha en que ocurrió el gasto (diferente de paid_at o created_at)
  # validates :expense_date, presence: { message: "La fecha del gasto es obligatoria." }


  def self.ransackable_attributes(auth_object = nil)
    # Asegúrate que todos estos campos existan en tu tabla 'expenses'
    ["admin_user_id", "amount", "created_at", "description", "expense_date", "id", "invoice", "name", "paid_at", "payment_method_id", "provider_id", "status", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    # Lista las asociaciones por las que quieres filtrar
    ["admin_user", "payment_method", "provider"]
  end
end