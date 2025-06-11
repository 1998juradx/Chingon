require 'faker'
require 'securerandom'

Payment.destroy_all
Debt.destroy_all
Client.destroy_all
AdminUser.destroy_all
puts "Limpiando tablas para el reporte PDF..."

puts "\nCreando Usuarios Administradores y Clientes de ejemplo..."
usuario_registrador = AdminUser.find_or_create_by!(email: 'admin@rocasol.com.co') do |admin|
  admin.password = "password123"
  admin.password_confirmation = "password123"
end

clientes_de_prueba = []
10.times do
  # 1. Genera un nombre de persona (que no tiene comas)
  nombre_valido = Faker::Name.name 
  
  # 2. Genera un teléfono con el formato correcto
  telefono_valido = "3#{Faker::Number.number(digits: 9)}"
  
  # 3. Asigna un estado válido del enum que tienes en tu modelo Client
  estado_valido = [:activo, :inactivo, :potencial, :vip].sample

  clientes_de_prueba << Client.create!(
    name: nombre_valido,
    phone: telefono_valido,
    email: Faker::Internet.unique.email,
    status: estado_valido
  )
end
puts "#{AdminUser.count} usuario administrador y #{Client.count} clientes creados."


puts "\nCreando 15 Deudas y sus Pagos..."
15.times do
  cliente_actual = clientes_de_prueba.sample
  usuario_actual = usuario_registrador # Solo hay un admin, así que lo usamos siempre
  
  monto_deuda = Faker::Number.between(from: 500, to: 10000) * 1000
  num_cuotas = [6, 12, 18, 24].sample
  valor_cuota = (monto_deuda.to_f / num_cuotas) * 1.15
  fecha_inicio = Faker::Date.between(from: 1.year.ago, to: 8.months.ago)
binding.pry

  nueva_deuda = Debt.new(
    client_id: Client.last.id,
    admin_user_id: AdminUser.last.id,
    installments: num_cuotas,
    due_day: 15,
    start_at: fecha_inicio,
    end_at: fecha_inicio + num_cuotas.months,
    interest_rate: 2.1,
    amount: monto_deuda,
    quota: valor_cuota.round(-2),
    currency: 'COP',
    token: SecureRandom.hex(10),
    status: 0
  )

  pagos_a_crear = rand(1..5)
  pagos_a_crear.times do |i|
    fecha_de_pago = fecha_inicio + (i + 1).months
    break if fecha_de_pago > Date.today

    nueva_deuda.payments.create!(
      client: cliente_actual,
      admin_user: usuario_actual,
      amount: nueva_deuda.quota,
      payment_date: fecha_de_pago,
      status: :aplicado,
      receipt_number: "REC-#{Faker::Number.number(digits: 4)}",
      due_at: fecha_de_pago,
      currency: 'COP',
      installment: i + 1,
      discount: 0,
      interest_amount: 0,
      paid_amount: nueva_deuda.quota,
      min_amount: nueva_deuda.quota
    )
  end
  puts "Deuda ##{nueva_deuda.id} creada para #{cliente_actual.name} con #{nueva_deuda.payments.count} pagos."
end

puts "\n¡Seeds mínimos para PDF completados!"