# app/admin/orders.rb
ActiveAdmin.register Order do

  # --- ORDEN EN EL MENÚ Y ETIQUETA ---
  menu priority: 3, label: "Pedidos" # O puedes usar: proc{ I18n.t("activerecord.models.order.other") }

  # --- PARÁMETROS PERMITIDOS ---
  # Ajusta estos según los campos que realmente quieras permitir y que existan en tus modelos.
  permit_params :client_id, :payment_method_id, :status, :order_date, :employee_id, :client_name, :total,
                  order_products_attributes: [:id, :product_id, :units, :price, :total, :status, :_destroy]

  # --- ACCIONES ---
  actions :all

  # --- SCOPES (Filtros rápidos) ---
  # Tu definición de scopes usando el enum del modelo Order está bien.
  # Asegúrate que los nombres :pendiente, :pagado, :entregado, :anulado coincidan con tu enum en Order.rb
  scope "Todos", :all, default: true
  scope "Pendientes", :pendiente # Active Admin usará el scope definido en tu modelo Order si existe, o where(status: :pendiente)
  scope "Pagados", :pagado
  scope "Entregados", :entregado
  scope "Anulados", :anulado

  # --- VISTA INDEX (Lista de Pedidos) ---
  index title: "Lista de Pedidos" do
    selectable_column
    id_column
    column "Cliente Registrado", :client # Muestra el nombre del cliente si la asociación existe
    column "Cliente (Nombre Manual)", :client_name
    column "Productos en Pedido" do |order|
      ul do
        order.order_products.includes(:product).each do |op|
          # Asegúrate que op.product no sea nil y op.units exista
          product_name = op.product.try(:name) || "Producto Desconocido"
          units_display = op.units.nil? ? "?" : op.units.to_i # Maneja nil para units
          li "#{product_name} X #{units_display}"
        end
      end
    end
    column "Monto Total", :total do |order|
      number_to_currency(order.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
    end
    tag_column "Estado", :status # Usa el enum 'status' del modelo Order
    column "Fecha del Pedido", :order_date
    column "Creado el", :created_at
    actions
  end

  # --- FILTROS (Barra Lateral) ---
  filter :client_name_cont, label: "Nombre Cliente (Manual)" # 'cont' significa 'contains' (contiene)
  filter :client, label: "Cliente Registrado" # Filtra por cliente asociado
  filter :total, label: "Monto Total"
  filter :status, label: "Estado", as: :select, collection: proc { Order.statuses.map { |k,v| [k.titleize, k] } } # Filtra por el enum status
  filter :order_date, label: "Fecha del Pedido"
  filter :created_at, label: "Fecha de Creación"
  filter :payment_method, label: "Método de Pago"
  filter :employee, label: "Empleado Asignado" # Si tienes la asociación configurada

  # --- VISTA SHOW (Detalle del Pedido) ---
  show title: proc{ "Detalle del Pedido ##{order.id}" } do
    attributes_table do
      row :id
      row "Cliente Registrado", :client
      row "Cliente (Nombre Manual)", :client_name
      row "Método de Pago", :payment_method
      row "Estado" do |order_instance| # Cambiado a order_instance para evitar conflicto con la variable order del bloque show
        status_tag order_instance.status
      end
      row "Monto Total" do |order_instance|
        number_to_currency(order_instance.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
      end
      row "Fecha del Pedido", :order_date
      row "Empleado Asignado", :employee # Si tienes esta asociación
      row "Creado el", :created_at
      row "Actualizado el", :updated_at
    end

    panel "Productos en este Pedido" do
      table_for order.order_products do
        column "Producto", :product
        column "Unidades", :units
        column "Precio Unitario (COP)" do |op|
          number_to_currency(op.price, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
        end
        column "Total Línea (COP)" do |op|
          number_to_currency(op.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
        end
        # column "Estado Ítem", :status # Si tienes un status en OrderProduct
      end
    end
    active_admin_comments
  end

  # --- FORMULARIO (Nuevo y Editar Pedido) ---
  form title: proc{ params[:action] == 'new' ? "Crear Nuevo Pedido" : "Editar Pedido ##{order.id}" } do |f|
    f.semantic_errors

    f.inputs "Información General del Pedido" do
      f.input :client, label: "Cliente Registrado (Seleccionar)", collection: Client.all.map{ |c| [c.name, c.id] }, include_blank: "Ninguno o ingresar manual"
      f.input :client_name, label: "Nombre Cliente (Si no está registrado o es diferente)"
      f.input :payment_method, label: "Método de Pago", include_blank: false
      f.input :status, label: "Estado del Pedido", as: :select, collection: Order.statuses.map { |k,v| [k.titleize, k] }, include_blank: false
      # El 'total' es mejor que se calcule automáticamente. Si permites editarlo, puede causar inconsistencias.
      # f.input :total, label: "Monto Total (COP)"
      f.input :order_date, label: "Fecha del Pedido", as: :datepicker
      # f.input :employee, label: "Empleado Asignado", collection: Employee.all.map{ |e| [e.name, e.id] }, include_blank: true # Si lo tienes
    end

    f.inputs "Productos del Pedido" do
      f.has_many :order_products, allow_destroy: true, new_record: 'Añadir Producto al Pedido', heading: false do |op_f|
        op_f.input :product, label: "Producto", collection: Product.all.map{ |p| [p.name, p.id] }, include_blank: "Seleccionar producto"
        op_f.input :units, label: "Unidades"
        op_f.input :price, label: "Precio Unitario (COP)" # Este debería ser el precio al momento de añadirlo
        # El 'total' y 'status' de OrderProduct se podrían calcular o tener valores por defecto en el modelo OrderProduct
        # op_f.input :total, label: "Total Línea (COP)"
        # op_f.input :status, label: "Estado del Ítem"
      end
    end
    f.actions
  end

  # --- Métodos Ransackable (Para búsquedas y filtros) ---
  def self.ransackable_attributes(auth_object = nil)
    # Asegúrate que estos campos existan en tu tabla 'orders' o sean métodos válidos
    # Quité 'name' y 'document' que estaban en tus filtros pero no en permit_params ni son comunes para Order
    ["client_id", "client_name", "created_at", "employee_id", "id", "order_date", "payment_method_id", "status", "total", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client", "employee", "order_products", "payment_method", "products"]
  end

  # --- CONTROLADOR ---
  # El controller block que tenías antes con 'go_to_dashboard' fue eliminado
  # porque causaba el error de ruta y su propósito no era claro para la funcionalidad estándar.
  # Active Admin maneja las redirecciones básicas.
  # Si necesitas una lógica de creación/actualización muy específica (como calcular el total
  # si tu modelo Order no lo hace con callbacks), puedes añadirla aquí.
  controller do
    # Ejemplo: Si quieres que el total del pedido se recalcule al guardar desde Active Admin
    # Esto es útil si no tienes un callback `before_save` o `after_save` en tu modelo Order
    # que actualice el total basado en los order_products.

    def save_and_recalculate_total(order_instance)
      # Guardar los order_products primero si es un pedido nuevo o se modificaron
      order_instance.save # Guarda el pedido y sus order_products anidados

      # Recalcular el total basado en los order_products guardados
      new_total = order_instance.order_products.joins(:product).sum('order_products.units * order_products.price')
      
      # Aquí podrías aplicar tu lógica de descuento de tacos si la tienes en el modelo Order
      # Ejemplo: new_total = order_instance.aplicar_descuento_tacos(new_total)

      # Actualiza el total en la base de datos sin disparar más callbacks
      order_instance.update_column(:total, new_total)
    end

    def create
      super do |format|
        if resource.persisted? # resource es la instancia de @order
          save_and_recalculate_total(resource)
          # Redirigir a donde quieras después de crear, por ejemplo, al 'show' del pedido
          # redirect_to admin_order_path(resource), notice: "Pedido creado exitosamente y total recalculado." and return
        end
      end
    end

    def update
      super do |format|
        if resource.persisted? && resource.valid? # O resource.errors.empty?
          save_and_recalculate_total(resource)
          # Redirigir a donde quieras después de actualizar
          # redirect_to admin_order_path(resource), notice: "Pedido actualizado exitosamente y total recalculado." and return
        end
      end
    end
  end

end