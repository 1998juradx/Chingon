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
    
    @order_products = OrderProduct.includes(:order).where(orders: {created_at: start_date.to_time.at_beginning_of_day..end_date.to_time.at_end_of_day}).references(:order)

    ventas = @order_products.map{|op| op.units * op.price}.sum
    clients = @order_products.map{|op| op.order_id}.uniq.count
    tacos = @order_products.select{|op| op.product_id == 1}.count
    combos = @order_products.select{|op| op.product_id == 5}.count
    gaseosa = @order_products.select{|op| op.product_id == 2}.count
    chelas = @order_products.select{|op| op.product_id == 3}.count
    caldos = @order_products.select{|op| op.product_id == 4}.count
    
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
        panel "Ventas" do
          span style: "font-size: 50px;" do
            number_to_currency ventas, precision: 0
          end
        end
      end
      column do
        panel "Clientes" do
          span style: "font-size: 50px;" do
            clients
          end
        end
      end

      column do
        panel "Tacos" do
          span style: "font-size: 50px;" do
            tacos + (combos * 3)
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
        panel "Caldos" do
          span style: "font-size: 50px;" do
            caldos
          end
        end
      end
      column do
        panel "Chelas" do
          span style: "font-size: 50px;" do
            chelas
          end
        end
      end

      column do
        panel "Gaseosas" do
          span style: "font-size: 50px;" do
            gaseosa
          end
        end
      end
    end

  
  end 
end
