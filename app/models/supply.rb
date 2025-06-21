class Supply < ApplicationRecord
  has_many :supply_inventories, dependent: :destroy
  has_many :product_supplies, dependent: :destroy
  has_many :products, through: :product_supplies

  enum status: { disponible: 0, inactivo: 1, agotado: 2 }

  validates :name,
    presence: { message: "El nombre del insumo no puede estar en blanco." },
    uniqueness: { case_sensitive: false, message: "Este nombre de insumo ya existe." },
    length: {
      minimum: 2,
      maximum: 100,
      too_short: "El nombre del insumo debe tener al menos %{count} caracteres.",
      too_long: "El nombre del insumo no puede tener más de %{count} caracteres."
    },
    format: {
      with: /\A[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ\s()#\-]+\z/,
      message: "El nombre del insumo contiene caracteres no permitidos."
    }

  validates :unit,
    presence: { message: "La unidad de medida no puede estar en blanco." },
    length: {
      minimum: 1,
      maximum: 25,
      too_short: "La unidad de medida debe tener al menos %{count} caracter.",
      too_long: "La unidad de medida no puede tener más de %{count} caracteres."
    },
    inclusion: {
      in: %w(kg gr gramo gramos litro ml cc unidad unidades docena atado bolsa paquete lata frasco caja bulto pieza),
      message: "'%{value}' no es una unidad válida. Permitidas: kg, gr, litro, ml, unidad, etc."
    }

  validates :status,
    presence: { message: "Debe seleccionar un estado para el insumo." }

  # Métodos Ransack para ActiveAdmin (evitan el error de allowlist)
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "status", "unit", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product_supplies", "products", "supply_inventories"]
  end
end