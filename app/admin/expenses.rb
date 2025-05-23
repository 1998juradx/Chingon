ActiveAdmin.register Expense do

  permit_params :name, :description, :admin_user_id, :payment_method_id, :paid_at, :invoice, :status, :cost

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
    column :admin_user
    column :name
    column :description
    column :cost do |i|
      number_to_currency i.cost, precision: 0
    end
    column :payment_method
    tag_column :status, interactive: true
    actions
  end

  filter :name

  form do |f|
    f.inputs "Detalles" do
      f.input :admin_user
      f.input :name
      f.input :description
      f.input :cost
      f.input :payment_method
      f.input :paid_at
      f.input :invoice
      f.input :status
    end
    f.actions
  end
  
end
