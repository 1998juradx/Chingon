ActiveAdmin.register Order do
  
  permit_params :name, :price, :payment_method_id, :client_id, :client_name, :status, :created_at, order_products_attributes: [:id, :product_id, :units, :price, :_destroy]
  
  actions :all
  
  scope "Todos" do |m|
    m.all
  end
  
  scope "Pendientes" do |m|
    m.where(status: Order::PENDING)
  end
  
  scope "Pagados" do |m|
    m.where(status: Order::PAID)
  end
  
  scope "Entregados" do |m|
    m.where(status: Order::DELIVERED)
  end
  
  scope "Anulados" do |m|
    m.where(status: Order::VOID)
  end

  index do
    # selectable_column
    id_column
    column :client do |order|
      order.client.present? ? order.client.name : order.client_name
    end
    column :order_products do |order|
      ul do
        order.order_products.includes(:product).order("product.position ASC").references(:product).each do |op|
          li do
            "#{op.product.name} X #{op.units.to_i}"
          end
        end
      end
    end
    column :total do |order|
      number_to_currency order.total, precision: 0
    end
    tag_column :status, interactive: true
    column :created_at
    actions
  end
  
  filter :name
  filter :document
  filter :created_at
  
  form do |f|
    if f.object.id.nil?
      f.object.init_product_holders
      f.inputs "Detalles" do
        f.input :payment_method
        f.input :client
        f.input :client_name
        Product.actives.order(position: :asc).each do |product|
          f.input "#{product.name.gsub("-", "_").gsub(" ", "_")}", as: :number, label: product.name, input_html: {min: 0}
        end
        if [1, 2].include? current_admin_user.id
          f.input :created_at, as: :date_time_picker
        end
      end
    else
      f.inputs "Detalles" do
        f.input :payment_method
        f.input :client#, input_html: {disabled: true}
        f.input :client_name, input_html: {disabled: true}

        f.has_many :order_products, allow_destroy: true do |ff|
          ff.input :product, input_html: {readonly: ff.object.id.present?}
          ff.input :units, input_html: {min: 0}
          ff.input :price, input_html: {readonly: ff.object.id.present?} 
        end

      end

    end
    f.actions
  end

  show do
    attributes_table do
      row :client do
        order.client.present? ? order.client.name : order.client_name
      end
      row :order_products do
        ul do
          order.order_products.includes(:product).order("product.position ASC").references(:product).each do |op|
            li do
              "#{op.product.name} X #{op.units.to_i}"
            end
          end
        end
      end
      row :total do
        number_to_currency order.total, precision: 0
      end
      row :created_at
      row "Actions" do
        render "admin/orders/print", {order: order}
      end
    end
  end

  collection_action :dashboard do
  end
  
  controller do

    before_action :go_to_dashboard, only: [:index]

    def go_to_dashboard
      redirect_to go_to_dashboard_admin_orders_path
    end
    
    def create 
      @order = Order.new payment_method_id: params[:order][:payment_method_id], client_id: params[:order][:client_id], client_name: params[:order][:client_name]
      
      @order.status = Order::PENDING
      
      
      if @order.save
        
        Product.actives.order(position: :asc).each do |product|
          aux_name = product.name.gsub("-", "_").gsub(" ", "_")
          
          if params[:order][aux_name].present? && params[:order][aux_name].to_i > 0
            @order.order_products.create product_id: product.id, price: product.price, units: params[:order][aux_name]
          end
        end
        new_order = Order.find(@order.id)
        new_order.created_at = params[:order][:created_at] if params[:order][:created_at].present?
        new_order.save
        
        redirect_to admin_order_path(new_order), notice: "Pedido creado"
      else
  
        render "new"
      end
    end
    
  end
  
end
