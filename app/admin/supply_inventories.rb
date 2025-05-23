ActiveAdmin.register SupplyInventory do

  permit_params :name, :unit, :status, :supply_id, :operation, :units, :cost

  actions :all, except: [:show, :edit]

  scope "Todos" do |m|
    m.all
  end

  scope "Activos" do |m|
    m.activo
  end

  scope "Anulados" do |m|
    m.anulado
  end

  index do
    # selectable_column
    id_column
    column :supply
    tag_column :operation, interactive: false
    column :units do |i|
      "#{i.units} #{i.supply&.unit}"
    end
    column :cost do |i|
      number_to_currency i.cost, precision: 0
    end
    actions
  end

  filter :name
  filter :operation

  form do |f|
    f.inputs "Detalles" do
      f.input :supply
      f.input :operation
      f.input :units
      f.input :cost
    end
    f.actions
  end
  
end
