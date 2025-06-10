require 'faker'

OrderProduct.destroy_all
Expense.destroy_all
SupplyInventory.destroy_all
Order.destroy_all
Product.destroy_all
Provider.destroy_all
Client.destroy_all
PaymentMethod.destroy_all
Employee.destroy_all
Supply.destroy_all
AdminUser.destroy_all
puts "Limpiando la base de datos (Manizales - Comida Mexicana)... ¡Hecho!"

puts "\nCreando 10 Usuarios Administradores..."
Faker::Internet.unique.clear
10.times do |i|
  AdminUser.find_or_create_by!(email: "admin#{i + 1}@chingon.com.co") do |admin|
    admin.password = 'password123'
    admin.password_confirmation = 'password123'
  end
end
puts "#{AdminUser.count} AdminUsers en la base de datos."

puts "\nCreando 15 Clientes..."
Faker::Name.unique.clear
posibles_estados_cliente = Client.statuses.keys if defined?(Client.statuses) && Client.statuses.is_a?(Hash)
posibles_estados_cliente ||= [:activo, :inactivo]
regex_nombre_valido = /\A[\p{L}\s\-']+\z/
clientes_creados = 0
while clientes_creados < 15
  nombre_cliente = Faker::Name.unique.name
  next unless nombre_cliente.present? && nombre_cliente.match?(regex_nombre_valido)
  telefono = "3#{Faker::Number.leading_zero_number(digits: 9)}"
  email = "#{nombre_cliente.downcase.gsub(/\W/, '')}#{clientes_creados}@gmail.com"
  Client.create!(
    name: nombre_cliente,
    phone: telefono,
    email: email,
    status: posibles_estados_cliente.sample
  )
  clientes_creados += 1
end
puts "#{Client.count} clientes creados."

puts "\nCreando 10 Empleados..."
Faker::Name.unique.clear
Faker::Internet.unique.clear
regex_nombre_valido_emp = /\A[\p{L}\s\-']+\z/
empleados_creados = 0
while empleados_creados < 10
  nombre_empleado = Faker::Name.unique.name_with_middle
  next unless nombre_empleado.present? && nombre_empleado.match?(regex_nombre_valido_emp)
  telefono_col = "3#{Faker::Number.leading_zero_number(digits: 9)}"
  email_emp = Faker::Internet.unique.email(
    name: "#{nombre_empleado.split.first.downcase.gsub(/\W/, '')}.#{empleados_creados + 1}",
    domain: 'chingon.com.co'
  )
  Employee.find_or_create_by!(email: email_emp) do |emp|
    emp.name = nombre_empleado
    emp.phone = telefono_col
  end
  empleados_creados += 1
end
puts "#{Employee.count} Empleados en la base de datos."

puts "\nCreando Métodos de Pago..."
metodos_pago_colombia = [
  "Efectivo (COP)", "Tarjeta Crédito/Débito", "Nequi", "Daviplata", "PSE", "Transferencia Bancolombia"
]
metodos_pago_colombia.each { |nombre| PaymentMethod.find_or_create_by!(name: nombre) }
puts "#{PaymentMethod.count} métodos de pago creados."

puts "\nCreando 15 Proveedores..."
Faker::Company.unique.clear
Faker::Internet.unique.clear
nombres_proveedores_manizales = [
  "Surtifruver La Montaña (Manizales)",
  "Carnes Premium del Eje",
  "Tortillería El Sol Naciente",
  "Lácteos Frescos de Caldas",
  "Distribuidora de Chiles 'Picante Mágico'",
  "Abarrotes 'El Cafetero'"
]
(15 - nombres_proveedores_manizales.length).times do |i|
  nombres_proveedores_manizales << "#{Faker::Company.unique.name} #{['S.A.S.', 'Ltda.', 'Dist. Manizales'].sample}"
end
nombres_proveedores_manizales.each_with_index do |nombre_proveedor, i|
  Provider.create!(
    name: nombre_proveedor.gsub(/#+\d*/, '').strip,
    phone: "606#{Faker::Number.number(digits: 7)}",
    email: Faker::Internet.unique.email(
      name: "#{nombre_proveedor.split.first.downcase.gsub(/\W/, '')}.#{i}",
      domain: 'proveedor.mzl.co'
    ),
    address: "#{Faker::Address.street_name} ##{Faker::Address.building_number}, Manizales"
  )
end
puts "#{Provider.count} proveedores creados."

puts "\nCreando Insumos..."
Faker::Food.unique.clear
posibles_estados_insumo = Supply.statuses.keys if defined?(Supply.statuses) && Supply.statuses.is_a?(Hash)
posibles_estados_insumo ||= [:activo, :inactivo]
insumos_data = [
  { name: "Tortilla de Maíz (Tacos)", unit: "kg", status: posibles_estados_insumo.sample },
  { name: "Tortilla de Harina (Burritos)", unit: "docena", status: posibles_estados_insumo.sample },
  { name: "Carne al Pastor", unit: "kg", status: posibles_estados_insumo.sample },
  { name: "Bistec de Res", unit: "kg", status: posibles_estados_insumo.sample },
  { name: "Pechuga de Pollo", unit: "kg", status: posibles_estados_insumo.sample }
]
insumos_data.each do |insumo_attrs|
  Supply.find_or_create_by!(name: insumo_attrs[:name]) do |s|
    s.unit = insumo_attrs[:unit]
    s.status = insumo_attrs[:status]
  end
end
binding.pry
puts "#{insumos_data.length} insumos predefinidos creados."

unidades_comunes = ["kg", "litro", "unidad", "atado", "bolsa", "paquete", "lata"]
puts "\nCreando 10 insumos adicionales con Faker..."
10.times do |i|
  nombre_insumo_faker = "#{Faker::Food.ingredient.capitalize} #{Faker::Color.color_name.capitalize} ##{i + 1}"
  Supply.find_or_create_by!(name: nombre_insumo_faker) do |s|
    s.unit = unidades_comunes.sample
    s.status = posibles_estados_insumo.sample
  end
end
binding.pry
minimo_total_insumos = 20
if Supply.count < minimo_total_insumos
  puts "\nAsegurando un mínimo de #{minimo_total_insumos} insumos en total..."
  while Supply.count < minimo_total_insumos
    nombre_insumo_extra_faker = "#{Faker::Food.spice.capitalize} #{Faker::Adjective.positive.capitalize} ##{Supply.count + 1}"
    Supply.find_or_create_by!(name: nombre_insumo_extra_faker) do |s|
      s.unit = unidades_comunes.sample
      s.status = posibles_estados_insumo.sample
    end
  end
end
binding.pry
puts "\nTotal de #{Supply.count} insumos creados."

puts "\nCreando Inventario de Insumos..."
todos_los_insumos = Supply.all.to_a
num_inventarios_a_crear = [15, todos_los_insumos.length].min
insumos_para_inventario = todos_los_insumos.empty? ? [] : todos_los_insumos.sample(num_inventarios_a_crear)
operaciones_validas = defined?(SupplyInventory.operations) && SupplyInventory.operations.is_a?(Hash) ? SupplyInventory.operations.keys : [:entrada, :salida]
estados_inventario_validos = defined?(SupplyInventory.statuses) && SupplyInventory.statuses.is_a?(Hash) ? SupplyInventory.statuses.keys : [:activo, :anulado]
insumos_para_inventario.each do |insumo_sample|
  SupplyInventory.find_or_create_by!(supply: insumo_sample) do |inv|
    inv.units = Faker::Number.between(from: 5.0, to: 100.0).round(1)
    inv.cost = Faker::Commerce.price(range: 500..20000.0).round(2)
    inv.operation = operaciones_validas.sample
    inv.status = estados_inventario_validos.sample
  end
end
binding.pry

puts "#{SupplyInventory.count} registros de inventario creados."

puts "\nCreando al menos 15 Productos (Comida Mexicana)..."
Faker::Coffee.unique.clear
Faker::Number.unique.clear
Faker::Adjective.unique.clear
Faker::Food.unique.clear
productos_data = [
  { name: "Tacos al Pastor (Orden de 3)", price: 16000 },
  { name: "Tacos de Asada (Orden de 3)", price: 17000 },
  { name: "Tacos de Carnitas (Orden de 3)", price: 16500 },
  { name: "Tacos de Pollo Adobado (Orden de 3)", price: 15000 },
  { name: "Burrito 'El Paisa' (Res)", price: 23000 },
  { name: "Quesadillas Sincronizadas (x2)", price: 19000 },
  { name: "Enchiladas 'Manizales' (Verdes)", price: 26000 }
]
num_productos_adicionales = 15 - productos_data.length
if num_productos_adicionales > 0
  num_productos_adicionales.times do
    nombres_base_producto_mexicano = [
      "Tostada", "Sope", "Gordita", "Flauta",
      "Huarache", "Pambazo", "Mollete", "Taco",
      "Burrito", "Quesadilla", "Enchilada"
    ]
    nombre_producto_faker = "#{nombres_base_producto_mexicano.sample} de #{Faker::Food.ingredient.capitalize} #{Faker::Adjective.positive.capitalize} ##{Product.count + 1}"
    nombre_producto_faker = "#{nombre_producto_faker} (v#{Faker::Number.digit})" if Product.exists?(name: nombre_producto_faker)
    productos_data << {
      name: nombre_producto_faker,
      price: Faker::Number.between(from: 1000, to: 35000).round(-2)
    }
  end
end
productos_data.each do |prod_data|
  precio_final = prod_data[:price]
  precio_final = 1000 if precio_final.nil? || precio_final <= 0
  Product.find_or_create_by!(name: prod_data[:name]) do |product|
    product.price = precio_final
  end
end
puts "\nTotal de #{Product.count} productos creados."

puts "\nCreando 15 Pedidos..."
todos_los_productos = Product.all.to_a
todos_los_metodos_pago = PaymentMethod.all.to_a
todos_los_empleados = Employee.all.to_a
todos_los_clientes = Client.all.to_a
status_pedido_options = [0, 1, 2, 3]
15.times do
  order_items_count = rand(1..3)
  order_total_calculated = 0
  temp_order_products_data = []
  break if todos_los_productos.empty?
  order_items_count.times do
    producto_seleccionado = todos_los_productos.sample
    next unless producto_seleccionado
    cantidad_unidades = rand(1..2)
    precio_unitario_en_pedido = producto_seleccionado.price
    temp_order_products_data << {
      product: producto_seleccionado,
      units: cantidad_unidades,
      price: precio_unitario_en_pedido,
      total_linea: (cantidad_unidades * precio_unitario_en_pedido).round(2),
      status_linea: [0, 1].sample
    }
    order_total_calculated += (cantidad_unidades * precio_unitario_en_pedido)
  end
  next if temp_order_products_data.empty?
  new_order_attributes = {
    status: status_pedido_options.sample,
    total: order_total_calculated.round(2),
    payment_method: todos_los_metodos_pago.sample
  }
  new_order_attributes[:client] = todos_los_clientes.sample if todos_los_clientes.any? && Order.column_names.include?('client_id')
  new_order_attributes[:employee] = todos_los_empleados.sample if todos_los_empleados.any? && Order.column_names.include?('employee_id')
  new_order_attributes[:order_date] = Faker::Time.between(from: 2.months.ago, to: Time.now) if Order.column_names.include?('order_date')
  new_order = Order.create!(new_order_attributes)
  temp_order_products_data.each do |item_data|
    OrderProduct.create!(
      order: new_order,
      product: item_data[:product],
      units: item_data[:units],
      price: item_data[:price],
      total: item_data[:total_linea],
      status: item_data[:status_linea]
    )
  end
end
puts "#{Order.count} pedidos creados."

puts "\nCreando 15 Gastos..."
todos_los_admin_users = AdminUser.all.to_a
descripciones_gastos_manizales = [
  "Arriendo local #{I18n.t('date.month_names', locale: :es, default: ['','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'])[Faker::Number.between(from: 1, to: 12)]}",
  "Servicios públicos (CHEC, Aguas Manizales)",
  "Nómina quincena", "Compra papelería",
  "Mantenimiento cocina", "Publicidad local",
  "Transporte insumos", "Gas propano"
]
status_gasto_options = [0, 1]
15.times do |i|
  metodo_pago_gasto = todos_los_metodos_pago.sample if todos_los_metodos_pago.any?
  admin_registra_gasto = todos_los_admin_users.sample if todos_los_admin_users.any?
  expense_attributes = {
    name: "Gasto General #{i + 1}",
    description: "#{descripciones_gastos_manizales.sample} - Ref #{Faker::Alphanumeric.alpha(number: 5)}",
    amount: Faker::Number.between(from: 15000, to: 2500000),
    status: status_gasto_options.sample,
    payment_method: metodo_pago_gasto,
    admin_user: admin_registra_gasto
  }
  expense_attributes[:provider] = Provider.all.sample if defined?(Provider) && Provider.any? && Expense.column_names.include?('provider_id')
  expense_attributes[:paid_at] = Faker::Date.between(from: 1.month.ago, to: Date.today) if Expense.column_names.include?('paid_at')
  expense_attributes[:invoice] = "INV-#{Faker::Number.number(digits: 5)}" if Expense.column_names.include?('invoice')
  expense_attributes[:expense_date] = Faker::Date.between(from: 2.months.ago, to: Date.today) if Expense.column_names.include?('expense_date')
  Expense.create!(expense_attributes)
end
puts "#{Expense.count} Gastos en la base de datos."

puts "\n¡Seeds para 'Chingon' (Comida Mexicana en COP) completados!"