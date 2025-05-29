ActiveAdmin.register Employee do
  permit_params :name, :email, :phone

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    actions
  end
end
