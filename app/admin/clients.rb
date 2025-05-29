ActiveAdmin.register Client do
  permit_params :name, :email, :phone, :status

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :status
    column :created_at
    actions
  end
end