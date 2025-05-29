ActiveAdmin.register Supply do
  menu parent: "Configuraciones", priority: 11

  permit_params :name, :unit, :status

  actions :all, except: [:destroy]

  scope "Todos", :all
  scope "Activos", :active
  scope "Inactivos", :inactive

  index do
    id_column
    column :name
    column :unit
    tag_column :status, interactive: true
    actions
  end

  filter :name
  filter :status, as: :select, collection: ["active", "inactive"]

  form do |f|
    f.inputs "Detalles del Insumo" do
      f.input :name
      f.input :unit
      f.input :status, as: :select, collection: ["active", "inactive"], include_blank: false
    end
    f.actions
  end
end