ActiveAdmin.register Product do
  permit_params :name, :price, :position, :status # Asegúrate que todos estos campos existan en tu tabla 'products'

  menu priority: 5, label: "Productos" # Añadimos la prioridad y etiqueta al menú

  filter :name, label: "Nombre del Producto"
  filter :price, label: "Precio Venta (COP)"
  filter :position, label: "Prioridad en Menú", as: :select, collection: proc { Product.positions.map { |k,v| [k.humanize, v] } } # Si 'position' es un enum
  filter :status, label: "Estado", as: :select, collection: proc { Product.statuses.map { |k,v| [k.humanize, v] } } # Si 'status' es un enum
  filter :created_at, label: "Fecha de Creación"

  index title: "Lista de Productos" do
    selectable_column
    id_column
    column "Nombre del Producto", :name
    column "Precio Venta (COP)", :price do |product|
      number_to_currency(product.price, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
    end
    tag_column "Prioridad", :position # Etiqueta más corta. Asume que 'position' es un enum.
    tag_column "Estado", :status   # Asume que 'status' es un enum.
    column "Creado el", :created_at
    column "Actualizado el", :updated_at
    actions
  end

  form title: proc { resource.new_record? ? "Crear Nuevo Producto" : "Editar Producto ##{resource.id}" } do |f|
    f.semantic_errors
    f.inputs "Detalles del Producto" do
      f.input :name, label: "Nombre del Producto"
      f.input :price, label: "Precio Venta (COP)", hint: "Ingrese el precio sin puntos ni comas. Ej: 15000"
      
      # Input para 'position' (Prioridad en Menú)
      # Si tu enum 'position' en el modelo Product tiene claves como "1", "2", etc. (strings):
      f.input :position, 
              label: "Prioridad en Menú", 
              as: :select, 
              collection: Product.positions.map { |k, v| ["Posición #{k}", v] }, # Muestra "Posición 1", "Posición 2", etc.
              include_blank: "Sin prioridad específica",
              hint: "Número más bajo aparece primero. Define el orden en listas y menús."

      
      if defined?(Product.statuses) && Product.statuses.is_a?(Hash)
        f.input :status, 
                label: "Estado del Producto", 
                as: :select, 
                collection: Product.statuses.map { |k, v| [k.humanize.titleize, k] }, # Muestra "Activo", "Inactivo"
                include_blank: false
      else
        # Si no hay enum, pero tienes un campo status de texto o número simple:
        # f.input :status, label: "Estado (ej: activo, inactivo)"
      end
    end
    f.actions
  end

  controller do
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "price", "position", "status", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["order_products", "product_supplies", "supplies", "orders"]
    end
  end
end