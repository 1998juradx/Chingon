# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Tablero Principal"

  content title: "Panel de Control" do
    panel "Seleccionar Rango de Fechas" do
      para "Filtra las ventas por un rango de fechas."
      render partial: "admin/shared/datepicker_filter", locals: { path: admin_dashboard_path }
    end

    columns do
      column do
        panel "Ventas Totales (COP)" do
          total = Order.where(status: 'completado').sum(:total_price)
          h2 number_to_currency(total, unit: "$", precision: 0, delimiter: ".")
        end
      end

      column do
        panel "Clientes Atendidos" do
          h2 Client.count
        end
      end

      column do
        panel "Pedidos Completados" do
          h2 Order.where(status: 'completado').count
        end
      end
    end

    columns do
      column do
        panel "Top 5 Productos Vendidos" do
          ul do
            OrderProduct
              .joins(:product)
              .group("products.name")
              .order("SUM(units) DESC")
              .limit(5)
              .sum(:units)
              .each do |name, cantidad|
                li "#{name} - #{cantidad.to_i} unidades"
              end
          end
        end
      end

      column do
        panel "Top Bebidas Vendidas" do
          ul do
            OrderProduct
              .joins(:product)
              .where("products.name LIKE '%Cerveza%'")
              .group("products.name")
              .order("SUM(units) DESC")
              .limit(5)
              .sum(:units)
              .each do |name, cantidad|
                li "#{name} - #{cantidad.to_i} unidades"
              end
          end
        end
      end
    end

    columns do
      column do
        panel "Ingresos" do
          ingresos = Order.where(status: 'completado').sum(:total_price)
          h3 number_to_currency(ingresos, unit: "$", precision: 0, delimiter: ".")
        end
      end

      column do
        panel "Gastos" do
          gastos = Expense.sum(:amount)
          h3 number_to_currency(gastos, unit: "$", precision: 0, delimiter: ".")
        end
      end

      column do
        panel "Ganancia Neta" do
          ingresos = Order.where(status: 'completado').sum(:total_price)
          gastos = Expense.sum(:amount)
          neta = ingresos - gastos
          h3 number_to_currency(neta, unit: "$", precision: 0, delimiter: ".")
        end
      end
    end
  end
end