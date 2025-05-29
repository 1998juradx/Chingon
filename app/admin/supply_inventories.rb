ActiveAdmin.register SupplyInventory do
  menu parent: "Inventario", priority: 1

  permit_params :supply_id, :operation, :units, :cost, :status

  actions :all, except: [:show]

  scope :all, default: true
  scope("Entradas")   { |scope| scope.entrada }
  scope("Salidas")    { |scope| scope.salida }
  scope("Anulados")   { |scope| scope.anulado }

  index do
    id_column
    column :supply
    tag_column :operation
    column :units do |i|
      "#{i.units} #{i.supply&.unit}"
    end
    column :cost do |i|
      number_to_currency(i.cost, unit: "$", precision: 0)
    end
    tag_column :status, interactive: true
    actions
  end

  filter :supply
  filter :operation, as: :select, collection: SupplyInventory.operations.keys
  filter :status, as: :select, collection: SupplyInventory.statuses.keys

  form do |f|
    f.inputs "Movimiento de Inventario" do
      f.input :supply
      f.input :operation, as: :select, collection: SupplyInventory.operations.keys
      f.input :units
      f.input :cost
      f.input :status, as: :select, collection: SupplyInventory.statuses.keys
    end
    f.actions
  end
end