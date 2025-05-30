# app/admin/providers.rb
ActiveAdmin.register Provider do # Asegúrate que el nombre del modelo sea Provider

  # 1. Configuración del Menú en Español y con Prioridad
  menu priority: 8, label: "Proveedores"

  # 2. Parámetros Permitidos (los que tenías)
  # Estos son los campos que puedes crear/editar desde Active Admin.
  permit_params :name, :email, :phone, :address

  # 3. Vista Index (la tabla que lista los proveedores)
  index title: "Lista de Proveedores" do
    selectable_column
    id_column
    column "Nombre del Proveedor", :name
    column "Correo Electrónico", :email
    column "Teléfono", :phone
    column "Dirección", :address
    column "Registrado el", :created_at # Es útil ver cuándo se creó
    actions # Muestra los botones de Ver, Editar, Eliminar
  end

  # 4. Filtros (para la barra lateral de búsqueda)
  filter :name_cont, label: "Nombre del Proveedor (contiene)"
  filter :email_cont, label: "Correo Electrónico (contiene)"
  filter :phone_cont, label: "Teléfono (contiene)"
  filter :address_cont, label: "Dirección (contiene)"
  filter :created_at, label: "Fecha de Registro"

  # 5. Formulario para Crear y Editar Proveedores
  form title: proc { params[:action] == 'new' ? "Registrar Nuevo Proveedor" : "Editar Proveedor" } do |f|
    f.semantic_errors # Muestra errores de validación del modelo si los hay

    f.inputs "Información del Proveedor" do
      f.input :name, label: "Nombre del Proveedor"
      f.input :email, label: "Correo Electrónico de Contacto"
      f.input :phone, label: "Teléfono de Contacto"
      f.input :address, label: "Dirección", as: :text # 'as: :text' para un campo de texto más grande
    end
    f.actions # Añade los botones de Guardar y Cancelar
  end

  # 6. Para que Active Admin pueda buscar/filtrar por estos campos (Ransack)
  # Es mejor tener estos métodos definidos en tu modelo app/models/provider.rb,
  # pero si los pones aquí en el controller block, también funcionarán para Active Admin.
  controller do
    def self.ransackable_attributes(auth_object = nil)
      # Lista los campos de tu tabla 'providers' que quieres que se puedan buscar/filtrar
      ["address", "created_at", "email", "id", "name", "phone", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      # Si tu modelo Provider tiene asociaciones (como con Gastos/Expenses)
      # y quieres usarlas en filtros, lista esas asociaciones aquí.
      # Ejemplo: ["expenses"] si Provider tiene has_many :expenses
      ["expenses"] # Ajusta según tus asociaciones reales
    end
  end

end