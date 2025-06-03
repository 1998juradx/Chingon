ActiveAdmin.register Order do

  menu priority: 3, label: "Pedidos"

  permit_params :client_id, :payment_method_id, :status, :order_date, :employee_id, :client_name, :total,
                  order_products_attributes: [:id, :product_id, :units, :price, :total, :status, :_destroy]

  actions :all

  scope "Todos", :all, default: true
  scope "Pendientes", :pendiente do |orders|
    orders.where(status: Order.statuses[:pendiente])
  end
  scope "Pagados", :pagado do |orders|
    orders.where(status: Order.statuses[:pagado])
  end
  scope "Entregados", :entregado do |orders|
    orders.where(status: Order.statuses[:entregado])
  end
  scope "Anulados", :anulado do |orders|
    orders.where(status: Order.statuses[:anulado])
  end

  index title: "Lista de Pedidos" do
    selectable_column
    id_column
    column "Cliente Registrado", :client
    column "Cliente (Nombre Manual)", :client_name
    column "Productos en Pedido" do |order|
      ul do
        order.order_products.includes(:product).each do |op|
          product_name = op.product.try(:name) || "Producto Desconocido"
          units_display = op.units.nil? ? "?" : op.units.to_i
          li "#{product_name} X #{units_display}"
        end
      end
    end
    column "Monto Total", :total do |order|
      number_to_currency(order.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
    end
    tag_column "Estado", :status
    column "Fecha del Pedido", :order_date
    column "Creado el", :created_at
    actions
  end

  filter :client_name_cont, label: "Nombre Cliente (Manual)"
  filter :client, label: "Cliente Registrado"
  filter :total, label: "Monto Total"
  filter :status, label: "Estado", as: :select, collection: proc { Order.statuses.map { |k,v| [k.humanize, v] } }
  filter :order_date, label: "Fecha del Pedido"
  filter :created_at, label: "Fecha de Creación"
  filter :payment_method, label: "Método de Pago"
  filter :employee, label: "Empleado Asignado"

  # --- VISTA SHOW (Detalle del Pedido) ---
  # 👇 CORRECCIÓN AQUÍ 👇
  show title: proc{ "Detalle del Pedido ##{resource.id}" } do
    attributes_table do
      row :id
      row "Cliente Registrado", :client
      row "Cliente (Nombre Manual)", :client_name
      row "Método de Pago", :payment_method
      row "Estado" do |order_instance| # Usamos order_instance aquí para claridad dentro del bloque
        status_tag order_instance.status
      end
      row "Monto Total" do |order_instance|
        number_to_currency(order_instance.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
      end
      row "Fecha del Pedido", :order_date
      row "Empleado Asignado", :employee
      row "Creado el", :created_at
      row "Actualizado el", :updated_at
    end

    panel "Productos en este Pedido" do
      table_for order.order_products do # Aquí 'order' se refiere a la instancia del pedido que se está mostrando
        column "Producto", :product
        column "Unidades", :units
        column "Precio Unitario (COP)" do |op|
          number_to_currency(op.price, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
        end
        column "Total Línea (COP)" do |op|
          number_to_currency(op.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
        end
      end
    end
    active_admin_comments
  end

  # --- FORMULARIO (Nuevo y Editar Pedido) ---
  form title: proc{ params[:action] == 'new' ? "Crear Nuevo Pedido" : "Editar Pedido ##{resource.id}" } do |f| # Usamos resource aquí también
    f.semantic_errors # Muestra errores de validación del modelo

    f.inputs "Información General del Pedido" do
      f.input :client, label: "Cliente Registrado (Seleccionar)", collection: Client.all.map{ |c| [c.name, c.id] }, include_blank: "Ninguno o ingresar manual"
      f.input :client_name, label: "Nombre Cliente (Si no está registrado o es diferente)"
      f.input :payment_method, label: "Método de Pago", include_blank: false
      f.input :status, label: "Estado del Pedido", as: :select, collection: Order.statuses.map { |k,v| [k.titleize, k] }, include_blank: false
      f.input :order_date, label: "Fecha del Pedido", as: :datepicker
    end

    f.inputs "Productos del Pedido" do
      f.has_many :order_products, allow_destroy: true, new_record: 'Añadir Producto al Pedido', heading: false do |op_f|
        op_f.input :product, label: "Producto", collection: Product.all.order(:name).map{ |p| [p.name, p.id] }, include_blank: "Seleccionar producto"
        op_f.input :units, label: "Unidades" # Campo 'units' de OrderProduct
        op_f.input :price, label: "Precio Unitario (COP)" # Campo 'price' de OrderProduct
      end
    end
    f.actions
  end

  def self.ransackable_attributes(auth_object = nil)
    ["client_id", "client_name", "created_at", "employee_id", "id", "order_date", "payment_method_id", "status", "total", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client", "employee", "order_products", "payment_method", "products"]
  end

  controller do
    def save_and_recalculate_total(order_instance)
      order_instance.save 
      new_total = order_instance.order_products.joins(:product).sum('order_products.units * order_products.price')
      order_instance.update_column(:total, new_total)
    end

    def create
      super do |format|
        if resource.persisted?
          save_and_recalculate_total(resource)
        end
      end
    end

    def update
      super do |format|
        if resource.persisted? && resource.valid?
          save_and_recalculate_total(resource)
        end
      end
    end
  end
end