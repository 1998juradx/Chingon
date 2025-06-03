class Client < ApplicationRecord
  has_many :orders, dependent: :destroy

  enum status: { activo: 0, inactivo: 1, potencial: 2, vip: 3 }

  validates :name,
            presence: { message: "El nombre no puede estar en blanco." },
            length: { 
              minimum: 2, 
              maximum: 100,
              too_short: "El nombre debe tener al menos %{count} letras.",
              too_long: "El nombre no puede tener más de %{count} letras." 
            },
            format: { 
              with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s'-]+\z/,
              message: "El nombre solo puede contener letras, espacios, apóstrofes o guiones."
            }

  validates :email,
            presence: { message: "El correo electrónico no puede estar en blanco." },
            uniqueness: { 
              case_sensitive: false, 
              message: "Este correo electrónico ya está registrado." 
            },
            format: { 
              with: URI::MailTo::EMAIL_REGEXP, 
              message: "El formato del correo electrónico no es válido."
            }

  validates :phone,
            presence: { message: "El teléfono no puede estar en blanco." },
            length: { is: 10, message: "El teléfono debe tener 10 dígitos." },
            format: { 
              with: /\A3\d{9}\z/,
              message: "El teléfono debe empezar con 3 y tener 10 dígitos numéricos."
            },
            uniqueness: { message: "Este número de teléfono ya está registrado." }

  validates :status, presence: { message: "Debe seleccionar un estado para el cliente." }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "name", "phone", "status", "updated_at", "address"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end
end