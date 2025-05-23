ActiveAdmin.register PaymentMethod do

  menu parent: "Configuraciones", priority: 11

  permit_params :name, :status

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
    tag_column :status, interactive: true
    actions
  end

  filter :name

  form do |f|
    f.inputs "Detalles" do
      f.input :name
    end
    f.actions
  end
  
end
