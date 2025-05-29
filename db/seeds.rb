# db/seeds.rb
require 'faker'

# --- INICIO: Limpieza de Tablas ---
puts "Limpiando la base de datos (Manizales - Comida Mexicana)..."
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
puts "Base de datos limpiada."
# --- FIN: Limpieza de Tablas ---

# --- Admin Users ---
puts "\nCreando al menos 15 Usuarios Administradores..."
Faker::Internet.unique.clear
admin_users_to_create = 15
admin_users_to_create.times do |i|
  AdminUser.find_or_create_by!(email: "admin#{i + 1}@chingoneria.com.co") do |admin|
    admin.password = 'password123'
    admin.password_confirmation = 'password123'
  end
end
puts "#{AdminUser.count} AdminUsers en la base de datos."

# --- Clientes (Manizales) ---
puts "\nCreando 15 Clientes..."
Faker::Name.unique.clear
15.times do |i|
  nombre_cliente = Faker::Name.unique.name
  Client.create!(
    name: nombre_cliente,
    phone: "3#{Faker::Number.leading_zero_number(digits: 9)}",
    email: "#{nombre_cliente.downcase.gsub(/\W/, '')}#{i}@gmail.com"
  )
end
puts "#{Client.count} clientes creados."

# --- Empleados (Manizales) ---
puts "\nCreando 15 Empleados..." # Ajustado a 15
Faker::Name.unique.clear
Faker::Internet.unique.clear # Para los emails de empleados
15.times do |i| # Ajustado a 15
  nombre_empleado = Faker::Name.unique.name_with_middle
  telefono_col = "3#{Faker::Number.leading_zero_number(digits: 9)}"
  Employee.find_or_create_by!(email: Faker::Internet.unique.email(name: "#{nombre_empleado.split.first.downcase.gsub(/\W/, '')}.#{i+1}", domain: 'chingoneria.com.co')) do |emp|
    emp.name = nombre_empleado
    emp.phone = telefono_col
  end
end
puts "#{Employee.count} Empleados en la base de datos."

# --- Métodos de Pago (Colombia) ---
puts "\nCreando al menos 15 Métodos de Pago (algunos ejemplos)..."
metodos_pago_colombia = [
  "Efectivo (COP)", "Tarjeta Crédito Visa", "Tarjeta Crédito Mastercard", "Tarjeta Débito",
  "Nequi", "Daviplata", "PSE - Bancolombia", "PSE - Davivienda", "Transferencia Bancaria Directa",
  "Bono de Regalo Chingón", "Consumo Interno Empleado", " RappiPay", " Sodexo Pass"
]
# Asegurar al menos 15
(15 - metodos_pago_colombia.length).times do |i|
  metodos_pago_colombia << "Otro Método #{i + Faker::Number.number(digits: 2)}"
end
metodos_pago_colombia.each { |nombre| PaymentMethod.find_or_create_by!(name: nombre) }
puts "#{PaymentMethod.count} métodos de pago creados."

# --- Proveedores (Manizales - Usando el modelo Provider) ---
puts "\nCreando 15 Proveedores..."
Faker::Company.unique.clear
Faker::Internet.unique.clear # Para emails de proveedores
nombres_proveedores_manizales = [
  "Surtifruver La Montaña (Manizales)", "Carnes Premium del Eje", "Tortillería El Sol Naciente",
  "Lácteos Frescos de Caldas", "Distribuidora de Chiles 'Picante Mágico'", "Abarrotes 'El Cafetero'"
]
(15 - nombres_proveedores_manizales.length).times do |i|
  nombres_proveedores_manizales << "#{Faker::Company.unique.name} #{['S.A.S.', 'Ltda.', 'Dist. Manizales'].sample} ##{i}"
end
nombres_proveedores_manizales.each_with_index do |nombre_proveedor, i|
  Provider.create!(
    name: nombre_proveedor,
    phone: "606#{Faker::Number.number(digits: 7)}",
    email: Faker::Internet.unique.email(name: nombre_proveedor.split.first.downcase.gsub(/\W/, '') + i.to_s, domain: 'proveedor.mzl.co'),
    address: "#{Faker::Address.street_name} ##{Faker::Address.building_number}, Manizales"
  )
end
puts "#{Provider.count} proveedores creados."

# --- Insumos (Supply) ---
puts "\nCreando al menos 15 Insumos..."
Faker::Food.unique.clear
insumos_data = [
  { name: "Tortilla de Maíz (Tacos)", unit: "kg" }, { name: "Tortilla de Harina (Burritos)", unit: "docena" },
  { name: "Carne al Pastor Adobada", unit: "kg" }, { name: "Bistec de Res para Asar", unit: "kg" },
  { name: "Pechuga de Pollo Deshebrada", unit: "kg" }, { name: "Carnitas de Cerdo", unit: "kg" },
  { name: "Queso Doble Crema Fresco", unit: "kg" }, { name: "Aguacate Hass Maduro", unit: "kg" }
]
insumos_data.each do |insumo|
  Supply.find_or_create_by!(name: insumo[:name]) do |s|
    s.unit = insumo[:unit]
  end
end
unidades_comunes = ["kg", "litro", "unidad", "atado", "bolsa", "paquete", "lata", "frasco"]
# Asegurar al menos 15 insumos en total
minimo_total_insumos = 15
if Supply.count < minimo_total_insumos
  puts "Creando insumos adicionales con Faker para alcanzar #{minimo_total_insumos}..."
  while Supply.count < minimo_total_insumos
    nombre_insumo_extra_faker = "#{Faker::Food.ingredient.capitalize} #{Faker::Color.color_name.capitalize} ##{Supply.count + 1}"
    Supply.find_or_create_by!(name: nombre_insumo_extra_faker) do |s|
      s.unit = unidades_comunes.sample
    end
  end
end
puts "\nTotal de #{Supply.count} insumos creados."

# --- Inventario de Insumos (SupplyInventory) ---
puts "\nCreando al menos 15 registros de Inventario de Insumos..."
todos_los_insumos = Supply.all.to_a # Convertir a Array para .sample
# Asegurar que intentamos crear 15 registros de inventario si hay suficientes insumos
num_inventarios_a_crear = [15, todos_los_insumos.length].min

insumos_para_inventario = todos_los_insumos.empty? ? [] : todos_los_insumos.sample(num_inventarios_a_crear)
insumos_para_inventario.each do |insumo_sample|
  SupplyInventory.find_or_create_by!(supply: insumo_sample) do |inv|
    inv.units = Faker::Number.between(from: 5.0, to: 100.0).round(1)
    # Si SupplyInventory tiene 'operation' o 'status', podrías inicializarlos:
    # inv.operation = 0 # Ej: 0 para compra/entrada inicial
    # inv.status = 0    # Ej: 0 para disponible
  end
end
puts "#{SupplyInventory.count} registros de inventario creados."

# --- Productos (Platillos Mexicanos - Precios en COP) ---
puts "\nCreando al menos 15 Productos (Comida Mexicana)..."
Faker::Coffee.unique.clear
Faker::Number.unique.clear
productos_data = [
  { name: "Tacos al Pastor (x3)", price: 16000, is_taco: true },
  { name: "Burrito 'El Paisa' (Res)", price: 23000, is_taco: false },
  { name: "Quesadillas Sincronizadas (x2)", price: 19000, is_taco: false },
  { name: "Enchiladas 'Manizales' (Verdes)", price: 26000, is_taco: false },
  { name: "Guacamole 'De la Finca'", price: 17000, is_taco: false },
  { name: "Sopa Azteca con Pollo", price: 18000, is_taco: false }
]
# Asegurar al menos 15 productos en total
num_productos_adicionales = 15 - productos_data.length
if num_productos_adicionales > 0
  num_productos_adicionales.times do
    es_taco_faker = [true, false, false].sample # Un poco más de variedad en si es taco
    nombre_base = ["Taco", "Burrito", "Quesadilla", "Enchilada", "Tostada", "Sope", "Gringa"].sample
    complemento = ["de Asada", "al Pastor", "de Carnitas", "de Pollo", "Vegetariano", "Mixto"].sample
    productos_data << {
      name: "#{nombre_base} #{complemento} ##{Faker::Number.unique.number(digits: 2)}",
      price: Faker::Number.between(from: 100, to: 280) * 100, # Entre 10.000 y 28.000
      is_taco: es_taco_faker
    }
  end
end
productos_data.each do |prod_data|
  Product.find_or_create_by!(name: prod_data[:name]) do |product|
    product.price = prod_data[:price]
    product.is_taco = prod_data.fetch(:is_taco, false) # Asume false si no está
  end
end
puts "#{Product.count} productos creados."

# --- Pedidos y OrderProducts ---
puts "\nCreando 15 Pedidos..." # Ajustado a 15
todos_los_productos = Product.all.to_a
todos_los_metodos_pago = PaymentMethod.all.to_a
todos_los_empleados = Employee.all.to_a
todos_los_clientes = Client.all.to_a
status_pedido_options = [0, 1, 2, 3] # Asumiendo 4 estados válidos para tu enum Order

15.times do # Ajustado a 15
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

# --- Gastos (Expense) ---
puts "\nCreando 15 Gastos..." # Ajustado a 15
todos_los_admin_users = AdminUser.all.to_a
descripciones_gastos_manizales = [
  "Arriendo local #{I18n.t('date.month_names', locale: :es, default: ['','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'])[Faker::Number.between(from: 1, to: 12)]}",
  "Servicios públicos (CHEC, Aguas Manizales)", "Nómina quincena", "Compra papelería",
  "Mantenimiento cocina", "Publicidad local", "Transporte insumos", "Gas propano"
]
status_gasto_options = [0, 1] # Ejemplo: 0 = pendiente, 1 = pagado

15.times do |i| # Ajustado a 15
  metodo_pago_gasto = todos_los_metodos_pago.sample if todos_los_metodos_pago.any?
  admin_registra_gasto = todos_los_admin_users.sample if todos_los_admin_users.any?

  expense_attributes = {
    name: "Gasto General #{i + 1}",
    description: "#{descripciones_gastos_manizales.sample} - Ref #{Faker::Alphanumeric.alpha(number: 5)}",
    amount: Faker::Number.between(from: 150, to: 25000) * 100, # Gastos entre 15.000 y 2.500.000 COP
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
# --- FIN Gastos ---

puts "\n¡Seeds para 'Chingonería Manizales' (Comida Mexicana en COP) completados!"