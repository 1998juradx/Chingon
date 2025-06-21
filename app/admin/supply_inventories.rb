# app/admin/supply_inventories.rb
ActiveAdmin.register SupplyInventory do

  # 1. Configuración del Menú en Español y con Prioridad
  # Ya tenías parent y priority, añadimos el label en español.
  menu label: "Inventarios de Insumos", parent: "Inventario", priority: 1

  # 2. Parámetros Permitidos (los que tenías)
  permit_params :supply_id, :operation, :units, :cost, :status

  # 3. Acciones (como lo tenías)
  actions :all, except: [:show] # No tendrás página de "Ver Detalle" individual

  # 4. Scopes (Filtros rápidos - como los tenías)
  # Asegúrate que :entrada, :salida, :anulado sean scopes definidos en tu modelo SupplyInventory
  # o que correspondan a valores de tu enum 'operation' o 'status'.
  scope "Todos", :all, default: true
  scope("Entradas")  { |scope| scope.entrada } # Asume scope :entrada en el modelo
  scope("Salidas")   { |scope| scope.salida }  # Asume scope :salida en el modelo
  scope("Anulados")  { |scope| scope.anulado } # Asume scope :anulado en el modelo (para status u operation)


  # 5. Vista Index (Lista de Inventarios) - Con Cambios
  index title: "Inventario de Insumos" do
    # selectable_column # Descomenta si quieres la columna para seleccionar varias filas
    id_column
    column "Insumo", :supply # Elige la columna 'supply' (mostrará el nombre del insumo asociado)
    
    # Columna Operación: Centrada y con etiqueta en Español
    tag_column "Operación", :operation, class: 'text-center-header text-center-cell'
    
    # Columna Unidades: Centrada, con etiqueta en Español y mostrando la unidad del insumo
    column "Unidades", :units, class: 'text-center-header text-center-cell' do |inv_item|
      # Muestra las unidades y la unidad de medida del insumo (ej. "10.5 kg")
      "#{number_with_precision inv_item.units, precision: 2, strip_insignificant_zeros: true} #{inv_item.supply&.unit}"
    end
    
    # Columna Costo: Centrada, con etiqueta en Español y formateada como moneda COP
    column "Costo Unitario", :cost, class: 'text-center-header text-center-cell' do |inv_item|
      number_to_currency(inv_item.cost, unit: "COP ", separator: ",", delimiter: ".", precision: 0)
    end
    
    # Columna Estado: Centrada y con etiqueta en Español
    tag_column "Estado", :status, interactive: true, class: 'text-center-header text-center-cell'
    
    actions # Botones de Editar, Eliminar
  end

  # 6. Filtros (Barra Lateral) - Con Etiquetas en Español
  filter :supply, label: "Insumo"
  # Asume que 'operation' y 'status' son enums en tu modelo SupplyInventory
  filter :operation, label: "Por Tipo de Operación", as: :select, collection: proc { SupplyInventory.operations.keys.map { |op| [op.humanize, op] } }
  filter :units, label: "Por Unidades"
  filter :cost, label: "Por Costo"
  filter :status, label: "Por Estado", as: :select, collection: proc { SupplyInventory.statuses.keys.map { |st| [st.humanize, st] } }
  filter :created_at, label: "Fecha de Creación"
  filter :updated_at, label: "Fecha de Actualización"


  # 7. Formulario (Nuevo y Editar) - Con Etiquetas en Español
  form title: proc { params[:action] == 'new' ? "Nuevo Movimiento de Inventario" : "Editar Movimiento de Inventario" } do |f|
    f.semantic_errors # Muestra errores de validación del modelo

    f.inputs "Detalles del Movimiento de Inventario" do
      f.input :supply, label: "Insumo", collection: Supply.all.order(:name).map { |s| [s.name, s.id] }, include_blank: "Seleccionar Insumo..."
      # Asume que 'operation' y 'status' son enums en tu modelo SupplyInventory
      f.input :operation, label: "Tipo de Operación", as: :select, collection: SupplyInventory.operations.keys.map { |op| [op.humanize, op] }, include_blank: false
      f.input :units, label: "Unidades/Cantidad"
      f.input :cost, label: "Costo Unitario (COP)"
      f.input :status, label: "Estado", as: :select, collection: SupplyInventory.statuses.keys.map { |st| [st.humanize, st] }, include_blank: false
    end
    f.actions # Botones de Guardar y Cancelar
  end

  # 8. Para que Active Admin pueda buscar/filtrar (Ransack)
  # Es mejor tener estos métodos en tu modelo app/models/supply_inventory.rb
  controller do
    def self.ransackable_attributes(auth_object = nil)
      # Lista los campos de tu tabla que quieres que se puedan buscar/filtrar
      # Asegúrate que estos campos existan en tu tabla 'supply_inventories'
      ["cost", "created_at", "id", "operation", "status", "supply_id", "units", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      # Lista las asociaciones por las que quieres filtrar
      ["supply"]
    end
  end

end