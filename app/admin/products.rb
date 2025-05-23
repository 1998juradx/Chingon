ActiveAdmin.register Product do

  menu parent: "Configuraciones", priority: 11

  permit_params :name, :price, :status, :is_taco, :position, product_supplies_attributes: [:supply_id, :units]

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
    column :price
    tag_column :position, interactive: true
    tag_column :status, interactive: true
    actions
  end
  
  filter :name
  filter :document
  
  form do |f|
    f.inputs "Detalles" do
      f.input :name
      f.input :price
      f.input :is_taco
      f.has_many :product_supplies, allow_destroy: true do |ff|
        ff.input :supply
        ff.input :units
      end
    end
    f.actions
  end
  
end
