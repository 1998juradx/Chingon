class Product < ApplicationRecord
  has_many :product_supplies, dependent: :destroy
  has_many :supplies, through: :product_supplies
  has_many :order_products, dependent: :nullify
  has_many :orders, through: :order_products

  accepts_nested_attributes_for :product_supplies, allow_destroy: true

  enum position: {
    "1" => 1,  "2" => 2,  "3" => 3,  "4" => 4,  "5" => 5,
    "6" => 6,  "7" => 7,  "8" => 8,  "9" => 9,  "10" => 10,
    "11" => 11, "12" => 12, "13" => 13, "14" => 14, "15" => 15,
    "16" => 16, "17" => 17, "18" => 18, "19" => 19, "20" => 20,
    "21" => 21, "22" => 22, "23" => 23, "24" => 24, "25" => 25,
    "26" => 26, "27" => 27, "28" => 28, "29" => 29, "30" => 30,
  }
  # Si usas un campo 'status' para tus productos:
  # enum status: { activo: 0, inactivo: 1, agotado: 2 }

  validates :name,
            presence: { message: "El nombre del producto no puede estar en blanco." },
            uniqueness: { case_sensitive: false, message: "Ese nombre de producto ya existe." },
            length: { 
              minimum: 3, 
              maximum: 100,
              too_short: "El nombre debe tener al menos %{count} caracteres.",
              too_long: "El nombre no puede tener más de %{count} caracteres."
            },
            format: {
              with: /\A[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ\s%()\/#\-x.,']+\z/,
              message: "El nombre contiene caracteres no permitidos."
            }

  validates :price,
            presence: { message: "El precio no puede estar en blanco." },
            numericality: { 
              greater_than_or_equal_to: 1, # O un valor mínimo práctico para tus precios en COP, ej: 500
              message: "El precio debe ser un número mayor o igual a 1." # O al mínimo que establezcas
            }
  
  # validates :status, presence: { message: "Debe seleccionar un estado para el producto." } # Si usas status
  # validates :position, presence: { message: "Debe seleccionar una posición." } # Si position es obligatorio

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "price", "position", "status", "updated_at"] # 'is_taco' eliminado
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_products", "product_supplies", "supplies", "orders"]
  end
end