ActiveAdmin.register AdminUser do

  menu parent: "Accesos", priority: 10

  permit_params :email, :password, :password_confirmation, :name

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs "Detalles" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
