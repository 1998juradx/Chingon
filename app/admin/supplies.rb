ActiveAdmin.register Supply do

  menu parent: "Configuraciones", priority: 11

  permit_params :name, :unit, :status

  actions :all, except: [:destroy]

  scope "Todos" do |m|
    m.all
  end

  scope "Activos" do |m|
    m.active
  end

  scope "Inactivos" do |m|
    m.inactive
  end

  index do
    # selectable_column
    id_column
    column :name
    column :unit
    tag_column :status, interactive: true
    actions
  end

  filter :name

  form do |f|
    f.inputs "Detalles" do
      f.input :name
      f.input :unit
    end
    f.actions
  end
  
end
