class Provider < ApplicationRecord
  has_many :expenses, dependent: :nullify # O :destroy, si prefieres

  validates :name,
            presence: { message: "El nombre del proveedor no puede estar en blanco." },
            length: { 
              minimum: 3, 
              maximum: 150,
              too_short: "El nombre del proveedor debe tener al menos %{count} caracteres.",
              too_long: "El nombre del proveedor no puede tener más de %{count} caracteres." 
            },
            format: { 
              with: %r{\A[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ\s.,'&()/\-]+\z}, # Expresión regular corregida
              message: "El nombre del proveedor contiene caracteres no válidos."
            }

  validates :email,
            presence: { message: "El correo electrónico no puede estar en blanco." },
            uniqueness: { 
              case_sensitive: false, 
              message: "Este correo electrónico de proveedor ya está registrado." 
            },
            format: { 
              with: URI::MailTo::EMAIL_REGEXP, 
              message: "El formato del correo electrónico no es válido."
            }

  validates :phone,
            presence: { message: "El teléfono del proveedor no puede estar en blanco." },
            length: { 
              minimum: 7,
              maximum: 20,
              message: "El teléfono debe tener una longitud válida (7-20 caracteres)."
            },
            format: { 
              with: %r{\A[0-9\s()+\-]*\z}, # Expresión regular corregida
              message: "El teléfono solo puede contener números y los caracteres ( ) + - o espacios."
            }

  validates :address,
            presence: { message: "La dirección del proveedor no puede estar en blanco." },
            length: { 
              minimum: 10, 
              maximum: 255,
              too_short: "La dirección debe tener al menos %{count} caracteres.",
              too_long: "La dirección no puede tener más de %{count} caracteres."
            }

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "email", "id", "name", "phone", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["expenses"] 
  end
end