# app/admin/employees.rb
ActiveAdmin.register Employee do
  permit_params :name, :phone, :email

  filter :name
  filter :phone
  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :phone
    column :email
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :phone
      row :email
      row :created_at
      row :updated_at
    end

    panel "Pedidos del empleado" do
      # Solo si existe la asociación has_many :orders en Employee
      table_for employee.orders do
        column :id
        column :order_number
        column :status
        column :total_price
      end
    end
  end

  form do |f|
    f.inputs "Detalles del empleado" do
      f.input :name
      f.input :phone
      f.input :email
    end
    f.actions
  end
end