class SupplyInventory < ApplicationRecord
  belongs_to :supply

  ACTIVE = 0
  VOID = 1

  ENTRADA = 1
  SALIDA = -1

  enum status: { activo: ACTIVE, anulado: VOID }
  enum operation: { entrada: ENTRADA, salida: SALIDA }

  validates :supply,
            presence: { message: "Debe seleccionar un insumo." }

  validates :units,
            presence: { message: "Las unidades no pueden estar en blanco." },
            numericality: {
              other_than: 0,
              message: "Las unidades deben ser un número diferente y mayor de cero."
            }

  validates :cost,
            presence: { message: "El costo unitario no puede estar en blanco." },
            numericality: {
              greater_than_or_equal_to: 0,
              message: "El costo unitario debe ser un número mayor o igual a cero."
            }

  validates :operation,
            presence: { message: "Debe seleccionar el tipo de operación." }

  validates :status,
            presence: { message: "Debe seleccionar un estado para el movimiento." }

  def self.ransackable_attributes(auth_object = nil)
    ["cost", "created_at", "id", "operation", "status", "supply_id", "units", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["supply"]
  end
end