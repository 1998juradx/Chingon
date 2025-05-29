# app/admin/products.rb
ActiveAdmin.register Product do
  permit_params :name, :price, :is_taco # Asegúrate que 'is_taco' exista en tu tabla products

  # Filtros
  filter :name
  filter :price
  filter :is_taco
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :price do |product|
      number_to_currency(product.price, unit: "COP $", separator: ",", delimiter: ".", precision: 0)
    end
    column "¿Es Taco?", :is_taco do |product|
      # Opción usando strings explícitos para las clases de status_tag
      # Active Admin usa estos strings para aplicar estilos CSS predefinidos.
      if product.is_taco
        status_tag "Sí", class: 'ok yes positive' # Clases comunes para 'sí' o estado positivo
      else
        status_tag "No", class: 'error no negative' # Clases comunes para 'no' o estado negativo/advertencia
      end
      # Otra alternativa si lo de arriba no toma el color deseado:
      # status_tag( (product.is_taco ? "Sí" : "No"), class: (product.is_taco ? 'status_yes' : 'status_no') )
      # Y luego en app/assets/stylesheets/active_admin.scss añades:
      # .status_tag.status_yes { background-color: green; color: white; }
      # .status_tag.status_no { background-color: red; color: white; }
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Detalles del Producto" do
      f.input :name
      f.input :price
      f.input :is_taco # Esto debería ser un checkbox
    end
    f.actions
  end

  # Atributos buscables por Ransack para Active Admin
  def self.ransackable_attributes(auth_object = nil)
    # Asegúrate que todos estos campos existan en tu tabla 'products'
    ["created_at", "id", "is_taco", "name", "price", "updated_at"]
  end

  # Asociaciones buscables por Ransack (si las tienes y quieres usarlas en filtros)
  # def self.ransackable_associations(auth_object = nil)
  #   [] # Ejemplo: ["order_products"]
  # end
end