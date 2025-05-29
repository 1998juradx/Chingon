# app/models/product.rb
class Product < ApplicationRecord
  # --- ASOCIACIONES ---
  has_many :product_supplies, dependent: :destroy
  has_many :supplies, through: :product_supplies

  has_many :order_products, dependent: :nullify # Esto significa que si borras un producto, en order_products el product_id se pondrá a nil.
                                              # Considera si quieres :destroy en lugar de :nullify,
                                              # lo que borraría las líneas de pedido si se borra el producto.
  has_many :orders, through: :order_products # Añadido para poder buscar/filtrar productos por pedidos

  # --- VALIDACIONES ---
  validates :name, presence: true
  validates :name, uniqueness: true
  # validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 } # Ejemplo si necesitas

  # --- ATRIBUTOS ANIDADOS ---
  accepts_nested_attributes_for :product_supplies, allow_destroy: true

  # --- ENUM PARA POSITION ---
  # Tu enum es funcional, aunque muy verboso. Si 'position' es solo para ordenar y es un simple entero,
  # a veces no se usa un enum a menos que los números tengan un significado especial como nombre.
  # Pero si te funciona, está bien.
  enum position: {
    "1" => 1,  "2" => 2,  "3" => 3,  "4" => 4,  "5" => 5,
    "6" => 6,  "7" => 7,  "8" => 8,  "9" => 9,  "10" => 10,
    "11" => 11, "12" => 12, "13" => 13, "14" => 14, "15" => 15,
    "16" => 16, "17" => 17, "18" => 18, "19" => 19, "20" => 20,
    "21" => 21, "22" => 22, "23" => 23, "24" => 24, "25" => 25,
    "26" => 26, "27" => 27, "28" => 28, "29" => 29, "30" => 30,
  }
  # Si tienes un campo 'status' en tu tabla 'products', considera definir un enum para él también:
  # enum status: { active: 0, inactive: 1, archived: 2 }


  # --- MÉTODOS PARA ACTIVE ADMIN / RANSACK ---

  # Atributos que Active Admin puede usar para buscar y filtrar
  def self.ransackable_attributes(auth_object = nil)
    # Añadimos 'is_taco' y 'position'. Quitamos 'status' a menos que realmente
    # tengas esa columna y quieras buscar por ella como un string/integer.
    # Si 'status' es un enum, se filtra de otra manera en Active Admin.
    ["created_at", "id", "name", "price", "updated_at", "is_taco", "position"]
  end

  # Asociaciones que Active Admin puede usar para buscar y filtrar
  # ¡ESTE ES EL MÉTODO QUE FALTABA Y CAUSABA EL ERROR!
  def self.ransackable_associations(auth_object = nil)
    # Lista las asociaciones de Product por las que quieras filtrar.
    # Asegúrate de que estas asociaciones estén definidas arriba en el modelo.
    ["order_products", "product_supplies", "supplies", "orders"]
  end

end