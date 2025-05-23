# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      javascript_include_tag "https://www.google.com/jsapi", "chartkick"
    end
    
    start_date = params[:start_at]
    end_date = params[:end_at]
    if start_date.blank?
      start_date = (Date.current.at_beginning_of_week).strftime("%Y-%m-%d")
    end
    
    if end_date.blank?
      end_date = (Date.current.at_end_of_week).strftime("%Y-%m-%d")
    end

    @orders = Order.includes(:payment_method).where(created_at: start_date.to_time.at_beginning_of_day..end_date.to_time.at_end_of_day).references(:payment_method)

    @today_orders = Order.includes(:payment_method).where(created_at: Date.current.at_beginning_of_day..Date.current.at_end_of_day).references(:payment_method)
    
    @order_products = OrderProduct.includes(:product).where(order_id: @orders.pluck(:id)).references(:product)
    
    columns do
      column do
        panel "Selector de rangos fechas" do
          form action: "/admin/dashboard", method: :get, autocomplete: "off" do |f|
            div do
              f.label "Fecha 1: "
              f.input :start_at, type: :datepicker, name: 'start_at', class: "datepicker", input_html: {autocomplet: "off"}
            end
            div style: "margin-top: 20px;" do
              f.label "Fecha 2: "
              f.input :end_at, type: :datepicker, name: 'end_at', class: "datepicker", input_html: {autocomplet: "off"}
            end
            div style: "margin-top: 20px;" do
              f.input :submit, type: :submit, class: "member_link", style: "width: 250px; height: 30px;"
            end
          end
        end
      end
    end

    columns do
      column do
        raw("<hr>")
      end
    end

    columns do
      column do
        panel "Caja del día" do
          bar_chart @today_orders.group("payment_methods.name").sum(:total)
        end
      end
    end

    columns do
      column do
        raw("<hr>")
      end
    end

    columns do
      column do
        panel "Ventas" do
          span style: "font-size: 50px;" do
            number_to_currency @orders.sum(:total), precision: 0
          end
        end
      end
      column do
        panel "Ordenes" do
          span style: "font-size: 50px;" do
            @orders.count
          end
        end
      end

      column do
        panel "Tacos" do
          span style: "font-size: 50px;" do
            @order_products.where(product: {is_taco: true}).sum(:units).to_i
          end
        end
      end
    end

    columns do
      column do
        raw("<hr>")
      end
    end

    columns do
      column do
        panel "Tacos" do
          pie_chart @order_products.where(products: {is_taco: true}).group("products.name").sum(:units)
        end
      end
      column do
        panel "Productos" do
          bar_chart @order_products.group("products.name").sum(:price)
        end
      end
    end
    columns do 
      column do
        panel "Productos (unidades)" do
          bar_chart @order_products.group("products.name").sum(:units)
        end
      end
    end
    columns do
      column do
        raw("<hr>")
      end
    end
    columns do
      column do
        panel "Ventas" do
          line_chart @orders.group_by_day(:created_at, time_zone: false).sum(:total)
        end
      end
    end

    columns do
      column do
        panel "Medios de pago" do
          bar_chart @orders.group("payment_methods.name").sum(:total)
        end
      end
    end

  
  end 
end
