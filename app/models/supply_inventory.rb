class SupplyInventory < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["cost", "created_at", "id", "operation", "status", "supply_id", "units", "updated_at"]
  end

  belongs_to :supply

  ACTIVE = 0
  VOID = 1

  ENTRADA = 1
  SALIDA = -1

  enum status: { activo: ACTIVE, anulado: VOID }
  enum operation: { entrada: ENTRADA, salida: SALIDA }

end
