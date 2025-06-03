ActiveAdmin.register_page "Accesos" do # <--- CAMBIO CLAVE: De "Dashboard" a "Accesos"
  # Ajusta la prioridad para que no colisione con el Dashboard real (si tienes uno en dashboard.rb)
  # Si este es tu dashboard principal y solo quieres que el menú "Accesos" lo apunte,
  # puedes mantener priority: 1, pero es conceptualmente confuso.
  # Vamos a asumir que "Accesos" es una sección separada.
  menu priority: 2, label: proc { I18n.t("ui_elements.access") } # <--- USA LA TRADUCCIÓN PARA "ACCESOS"

  content title: proc { I18n.t("ui_elements.access") } do # <--- TÍTULO DE LA PÁGINA TAMBIÉN TRADUCIDO
    # El resto de tu lógica de dashboard se mantiene aquí, pero ahora bajo la página "Accesos"
    div class: "blank_slate_container", id: "dashboard_default_message" do
      # javascript_include_tag "https://www.google.com/jsapi", "chartkick" # Descomenta si lo sigues necesitando
    end
    
    start_date = params[:start_at]
    end_date = params[:end_at]
    if start_date.blank?
      start_date = (Date.current.at_beginning_of_week).strftime("%Y-%m-%d")
    end
    
    if end_date.blank?
      end_date = (Date.current.at_end_of_week).strftime("%Y-%m-%d")
    end
    
    # Tu lógica de consulta (sin cambios)
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
        # panel "Selector de rangos fechas" do # <--- TRADUCIR ESTO
        panel I18n.t("active_admin_custom.panels.date_range_selector") do
          # CAMBIO CLAVE: La acción del formulario debe apuntar a la ruta correcta de esta página
          # Si registraste la página como "Accesos", la ruta será /admin/accesos
          form action: admin_accesos_path, method: :get, autocomplete: "off" do |f| # <--- USA EL HELPER DE RUTA
            div do
              # f.label "Fecha 1: " # <--- TRADUCIR ESTO
              f.label I18n.t("active_admin_custom.labels.date_1")
              f.input :start_at, type: :datepicker, name: 'start_at', class: "datepicker", input_html: {autocomplete: "off", value: start_date} # Añadido value
            end
            div style: "margin-top: 20px;" do
              # f.label "Fecha 2: " # <--- TRADUCIR ESTO
              f.label I18n.t("active_admin_custom.labels.date_2")
              f.input :end_at, type: :datepicker, name: 'end_at', class: "datepicker", input_html: {autocomplete: "off", value: end_date} # Añadido value
            end
            div style: "margin-top: 20px;" do
              # f.input :submit, type: :submit, class: "member_link", style: "width: 250px; height: 30px;" # <--- TRADUCIR VALUE DEL BOTÓN
              f.input :submit, type: :submit, value: I18n.t("buttons.filter"), class: "member_link", style: "width: 250px; height: 30px;"
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
        # panel "Ventas" do # <--- TRADUCIR
        panel I18n.t("active_admin_custom.panels.sales") do
          span style: "font-size: 50px;" do
            number_to_currency ventas, precision: 0
          end
        end
      end
      column do
        # panel "Clientes" do # <--- TRADUCIR
        panel I18n.t("active_admin_custom.panels.clients") do
          span style: "font-size: 50px;" do
            clients
          end
        end
      end
      column do
        # panel "Tacos" do # <--- TRADUCIR
        panel I18n.t("active_admin_custom.panels.tacos") do
          span style: "font-size: 50px;" do
            tacos + (combos * 3) # Asumo que esta lógica es correcta
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
        # panel "Caldos" do # <--- TRADUCIR
        panel I18n.t("active_admin_custom.panels.broths") do
          span style: "font-size: 50px;" do
            caldos
          end
        end
      end
      column do
        # panel "Chelas" do # <--- TRADUCIR
        panel I18n.t("active_admin_custom.panels.beers") do
          span style: "font-size: 50px;" do
            chelas
          end
        end
      end
      column do
        # panel "Gaseosas" do # <--- TRADUCIR
        panel I18n.t("active_admin_custom.panels.sodas") do
          span style: "font-size: 50px;" do
            gaseosa
          end
        end
      end
    end
  end 
end