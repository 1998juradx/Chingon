

ActiveAdmin.register Client do

  # 1. Configuración del Menú en Español y con Prioridad
  menu priority: 4, label: "Clientes"

  # 2. Parámetros Permitidos (los que tenías, incluyendo :status)
  # Estos son los campos que puedes crear/editar desde Active Admin.
  # Asegúrate de que :status sea un campo que realmente exista en tu modelo Client.
  permit_params :name, :email, :phone, :status

  # 3. Vista Index (la tabla que lista los clientes)
  # Mantendremos tus columnas y añadiremos títulos en español.
  index title: "Lista de Clientes" do
    selectable_column # Para seleccionar varias filas
    id_column         # Muestra la columna ID
    column "Nombre del Cliente", :name
    column "Correo Electrónico", :email
    column "Teléfono", :phone
    # Para el 'status', si es un enum o un booleano, tag_column se ve mejor:
    # Si 'status' es un string simple, solo 'column :status' está bien.
    # Asumamos que 'status' podría ser algo como 'activo'/'inactivo'.
    tag_column "Estado", :status # Si 'status' es un enum en tu modelo Client, esto funcionará bien.
                               # Si es un string, puedes hacer: column "Estado", :status
    column "Fecha de Creación", :created_at
    actions # Muestra los botones de Ver, Editar, Eliminar
  end

  # 4. Filtros (para la barra lateral de búsqueda)
  # Estos son opcionales, pero útiles.
  filter :name, label: "Por Nombre del Cliente"
  filter :email, label: "Por Correo Electrónico"
  filter :phone, label: "Por Teléfono"
  # Si 'status' es un enum en tu modelo Client:
  # filter :status, label: "Por Estado", as: :select, collection: proc { Client.statuses.map { |k,v| [k.humanize, v] } }
  # Si 'status' es un string simple:
  filter :status_cont, label: "Por Estado (contiene)" # 'cont' busca si el texto contiene la palabra
  filter :created_at, label: "Por Fecha de Creación"

  # 5. Formulario para Crear y Editar Clientes
  # Esto te permitirá crear y editar clientes desde la interfaz de Active Admin.
  form title: proc { params[:action] == 'new' ? "Registrar Nuevo Cliente" : "Editar Cliente" } do |f|
    f.semantic_errors # Muestra errores de validación del modelo si los hay

    f.inputs "Información del Cliente" do
      f.input :name, label: "Nombre Completo"
      f.input :email, label: "Correo Electrónico"
      f.input :phone, label: "Teléfono de Contacto"
      # Si 'status' es un enum en tu modelo Client:
      # f.input :status, label: "Estado", as: :select, collection: Client.statuses.keys.map { |s| [s.humanize, s] }, include_blank: false
      # Si 'status' es un campo de texto o un conjunto simple de opciones:
      f.input :status, label: "Estado" # O como :select si tienes opciones fijas
    end
    f.actions # Añade los botones de Guardar y Cancelar
  end

  # 6. Para que Active Admin pueda buscar/filtrar por estos campos (Ransack)
  # Necesitas estos métodos en tu modelo app/models/client.rb
  # Si no los tienes, Active Admin podría dar error al intentar filtrar.
  # Te los pongo aquí como referencia para tu modelo Client.rb:
  #
  # class Client < ApplicationRecord
  #   # ... tus otras cosas del modelo ...
  #
  #   def self.ransackable_attributes(auth_object = nil)
  #     ["created_at", "email", "id", "name", "phone", "status", "updated_at"] # Incluye todos los campos por los que quieras filtrar/buscar
  #   end
  #
  #   def self.ransackable_associations(auth_object = nil)
  #     ["orders"] # Ejemplo, si Client tiene una relación 'orders' y quieres filtrar por ellas
  #   end
  # end
  # Por ahora, los dejaremos aquí en el archivo de Active Admin, pero lo ideal es que estén en el modelo.
  controller do
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "email", "id", "name", "phone", "status", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      # Si tu modelo Client tiene asociaciones (como con Pedidos) y quieres usarlas en filtros,
      # lista esas asociaciones aquí. Ejemplo: ["orders"]
      [] # Por ahora lo dejamos vacío si no tienes asociaciones directas para filtrar desde Client
    end
  end

end