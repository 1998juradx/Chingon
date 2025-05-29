# app/admin/orders.rb
ActiveAdmin.register Order do

  # --- PARÁMETROS PERMITIDOS ---
  # Define los atributos de Order que se pueden modificar y los de order_products anidados.
  # Asegúrate que los atributos de Order (client_id, payment_method_id, status, total, order_date, employee_id)
  # existan en tu tabla 'orders'. El 'total' usualmente se calcula, no se ingresa directamente.
  permit_params :client_id, :payment_method_id, :status, :order_date, :employee_id, :client_name, # Atributos de Order
                  order_products_attributes: [:id, :product_id, :units, :price, :total, :status, :_destroy]
                  # :client_name es para el caso de que el cliente no esté registrado

  # --- ACCIONES ---
  actions :all # index, show, new, create, edit, update, destroy

  # --- SCOPES (Filtros rápidos) ---
  # Tu definición de scopes usando las constantes del modelo Order está bien.
  # Asegúrate que las constantes PENDING, PAID, DELIVERED, VOID estén definidas en tu modelo Order.rb
  scope "Todos", :all, default: true
  scope "Pendientes", :pendiente do |orders| # Usando el nombre del enum
    orders.where(status: Order.statuses[:pendiente])
  end
  scope "Pagados", :pagado do |orders|
    orders.where(status: Order.statuses[:pagado])
  end
  scope "Entregados", :entregado do |orders| # Asumiendo que tienes este estado en tu enum
    orders.where(status: Order.statuses[:entregado])
  end
  scope "Anulados", :anulado do |orders|
    orders.where(status: Order.statuses[:anulado])
  end

  # --- VISTA INDEX (Lista de Pedidos) ---
  index do
    selectable_column
    id_column
    column :client # Muestra el nombre del cliente si la asociación existe
    column "Nombre Cliente (si no registrado)", :client_name
    column "Productos" do |order|
      ul do
        # Usamos los campos correctos de OrderProduct: product.name, units
        order.order_products.includes(:product).each do |op|
          li "#{op.product.try(:name) || 'Producto no encontrado'} X #{op.units.to_i}"
        end
      end
    end
    column :total do |order|
      # Usamos el helper de Rails para formatear moneda.
      # Asegúrate que tu config/locales/es.yml tenga la configuración de moneda para COP.
      number_to_currency(order.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
    end
    tag_column :status # Esto usa tu enum 'status' del modelo Order
    column "Fecha del Pedido", :order_date # Si tienes esta columna
    column "Creado el", :created_at
    actions
  end

  # --- FILTROS (Barra Lateral) ---
  filter :client # Filtra por cliente asociado
  filter :client_name_cont # Filtra por nombre de cliente no registrado (contiene)
  filter :total
  filter :status, as: :select, collection: proc { Order.statuses.map { |k,v| [k.humanize, v] } } # Filtra por el enum status
  filter :order_date # Si tienes esta columna
  filter :created_at

  # --- VISTA SHOW (Detalle del Pedido) ---
  show do
    attributes_table do
      row :id
      row :client
      row "Nombre Cliente (si no registrado)", :client_name
      row :payment_method
      row :status do |order|
        status_tag order.status
      end
      row :total do |order|
        number_to_currency(order.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
      end
      row :order_date
      row :employee # Si tienes esta asociación
      row :created_at
      row :updated_at
    end

    panel "Productos en este Pedido" do
      table_for order.order_products do
        column "Producto", :product
        column "Unidades", :units # Campo 'units' de OrderProduct
        column "Precio Unitario" do |op| # Campo 'price' de OrderProduct
          number_to_currency(op.price, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
        end
        column "Total Línea" do |op| # Campo 'total' de OrderProduct
          number_to_currency(op.total, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
        end
        # column "Estado Ítem", :status # Si tienes un status en OrderProduct
      end
    end
    # Si tienes un partial para imprimir, puedes dejarlo:
    # panel "Acciones" do
    #   render "admin/orders/print", {order: order}
    # end
    active_admin_comments
  end

  # --- FORMULARIO (Nuevo y Editar Pedido) ---
  form do |f|
    f.semantic_errors # Muestra errores de validación del modelo

    f.inputs "Información del Pedido" do
      f.input :client # Selector para clientes existentes (asegúrate que Client.rb exista)
      f.input :client_name, label: "Nombre Cliente (si no está registrado)" # Campo de texto
      f.input :payment_method # Selector para métodos de pago
      f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.titleize, s] }, include_blank: false # Usa tu enum
      # El total se debería calcular automáticamente por el modelo Order o al guardar OrderProducts
      # f.input :total # Generalmente no se edita directamente
      f.input :order_date, as: :datepicker # Si tienes este campo
      # f.input :employee # Si quieres asignar un empleado
    end

    f.inputs "Productos del Pedido" do
      f.has_many :order_products, allow_destroy: true, new_record: 'Añadir Producto' do |op_f|
        op_f.input :product # Selector de productos existentes
        op_f.input :units, label: "Unidades" # Campo 'units' de OrderProduct
        op_f.input :price, label: "Precio Unitario (COP)" # Campo 'price' de OrderProduct
        # El 'total' y 'status' de OrderProduct se podrían calcular o dejar por defecto
        # op_f.input :total
        # op_f.input :status
      end
    end
    f.actions
  end

  # --- CONTROLADOR (Lógica Personalizada) ---
  # Hemos eliminado el before_action y go_to_dashboard problemático.
  # La lógica de 'create' de Active Admin debería funcionar bien con accepts_nested_attributes_for.
  # Si necesitas una lógica de creación MUY personalizada, puedes sobreescribir 'create' aquí,
  # pero intenta usar las convenciones primero. Tu método 'create' anterior era complejo y
  # propenso a errores si los nombres de los productos cambiaban.

  # controller do
  #   def create
  #     # Si necesitas lógica especial al crear, la pones aquí.
  #     # Por ejemplo, para calcular el total ANTES de guardar si no usas callbacks en el modelo:
  #     super do |format|
  #       if @order.persisted?
  #         # Recalcular el total basado en los order_products guardados
  #         new_total = @order.order_products.sum { |op| (op.units || 0) * (op.price || 0) }
  #         # Lógica de descuento de tacos si la tienes en el modelo Order y quieres aplicarla aquí
  #         # ...
  #         @order.update_column(:total, new_total) # Actualiza sin disparar callbacks
  #       end
  #     end
  #   end

  #   # def update
  #   #   # Lógica especial al actualizar
  #   #   super do |format|
  #   #     if @order.persisted? && @order.valid? # o saved_changes?
  #   #       # Recalcular total si es necesario
  #   #       new_total = @order.order_products.sum { |op| (op.units || 0) * (op.price || 0) }
  #   #       @order.update_column(:total, new_total)
  #   #     end
  #   #   end
  #   # end
  # end

end