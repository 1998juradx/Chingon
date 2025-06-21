# app/models/employee.rb
class Employee < ApplicationRecord
  # Aquí podrían ir tus validaciones o asociaciones si las tienes
  # Ejemplo:
  # validates :name, presence: true
  # validates :email, presence: true, uniqueness: true
  # has_many :orders # Si un empleado puede tener muchos pedidos

  # --- ESTE ES EL MÉTODO QUE NECESITAS AÑADIR ---
  def self.ransackable_attributes(auth_object = nil)
    # Lista los campos de tu tabla 'employees' que quieres que se puedan buscar
    # El error te sugiere estos, que parecen correctos para tu modelo Employee:
    ["created_at", "email", "id", "name", "phone", "updated_at"]
    # Si tienes otros campos en Employee que quieras buscar, añádelos a esta lista.
    # Si hay campos sensibles que NO quieres que se puedan buscar (como una contraseña si la tuvieras),
    # asegúrate de NO incluirlos aquí.
  end

  # (Opcional, pero buena práctica si también quieres buscar/filtrar por modelos asociados)
  # def self.ransackable_associations(auth_object = nil)
  #   ["orders"] # Ejemplo, si quieres filtrar empleados por sus pedidos
  # end

end