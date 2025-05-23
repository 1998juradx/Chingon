ActiveAdmin.register Client do

  permit_params :name, :phone, :email, :status

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
    column :document
    column :phone
    column :email
    tag_column :status, interactive: true
    actions
  end

  filter :name
  filter :document

  form do |f|
    f.inputs "Detalles" do
      f.input :name
      f.input :email
      f.input :phone
    end
    f.actions
  end
  
end
