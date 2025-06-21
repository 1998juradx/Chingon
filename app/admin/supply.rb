ActiveAdmin.register Supply do
  menu parent: "Configuraciones", priority: 11

  permit_params :name, :unit, :status

  actions :all, except: [:destroy]

  scope "Todos" do |su|
    su.all
  end

  scope "Disponibles" do |su|
    su.disponible
  end

  scope "Inactivos" do |su|
    su.inactivo
  end

  scope "Agotados" do |su|
    su.agotado
  end

  index do
    id_column
    column :name
    column :unit
    tag_column :status, interactive: true
    actions
  end

  filter :name
  filter :status, as: :select, collection: Supply.statuses.keys

  form do |f|
    f.inputs "Detalles del Insumo" do
      f.input :name,
              required: true,
              input_html: { maxlength: 100 }

      f.input :unit,
              required: true,
              as: :select,
              collection: %w(
                kg gr gramo gramos litro ml cc unidad unidades
                docena atado bolsa paquete lata frasco caja bulto pieza
              ),
              prompt: "Seleccione unidad"

      f.input :status,
              as: :select,
              collection: Supply.statuses.keys.map { |k| [k.humanize.capitalize, k] },
              prompt: "Seleccione estado"
    end
    f.actions
  end
end