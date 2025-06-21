require 'faker'
require 'securerandom'

Payment.destroy_all
Debt.destroy_all
Client.destroy_all
AdminUser.destroy_all
User.destroy_all
puts "Limpiando tablas para el reporte PDF..."

puts "\nCreando Usuarios Administradores y Clientes de ejemplo..."
15.times do |i|
  a = AdminUser.new(
    email: "#{i}-#{Faker::Internet.unique.email}",
    password: "password123",
    password_confirmation: "password123",
    name: Faker::Name.name,
    phone: Faker::PhoneNumber.phone_number
  )
  a.save
  puts "Usuario administrador #{a.id} creado con éxito #{a.email}"
end

puts "Iniciando Creación de 15 Usuarios..."
15.times do
  u = User.new(
    name: Faker::Name.name,
    lastname: Faker::Name.last_name
  )
  u.save
  puts "Usuario #{u.id} creado con éxito #{u.name} #{u.lastname}"
end
puts "Terminado Creación de 15 Usuarios"
puts "Iniciando Creación de 10 Clientes..."
10.times do |i|
  c = Client.new(
    name: "#{Faker::Name.name}",
    phone: "3#{Faker::Number.number(digits: 9)}",
    email: "#{i}-#{Faker::Internet.unique.email}",
    status: [0, 1, 2, 3].sample
  )
  c.save
  puts "Cliente #{c.id} creado con éxito #{c.name} #{c.phone} #{c.email} #{c.status}"
end
puts "Terminado Creación de 10 Clientes"

puts "Iniciando Creación de 10 Deudas..."
10.times do |i|
  d = Debt.new(
    client_id: Client.pluck(:id).sample,
    user_id: User.pluck(:id).sample,
    installments: [12, 24, 36, 48, 60].sample,
    due_day: [1, 15, 30].sample,
    start_at: Date.today,
    end_at: Date.today + [12, 24, 36, 48, 60].sample.months,
    interest_rate: 0.1,
    amount: [1000000, 2000000, 3000000, 4000000, 5000000, 6000000, 7000000, 8000000, 9000000, 10000000].sample,
    quota: [100000, 200000, 300000, 400000, 500000].sample,
    currency: "COP",
    token: SecureRandom.hex(10),
    status: [0, 1, 2].sample,
    admin_user_id: AdminUser.pluck(:id).sample
  )
  d.save
  puts "Deuda #{d.id} creada con éxito #{d.client_id} #{d.user_id} #{d.installments} #{d.due_day} #{d.start_at} #{d.end_at} #{d.interest_rate} #{d.amount} #{d.quota} #{d.currency} #{d.token} #{d.status}"
end
puts "Terminado Creación de 10 Deudas"

puts "\n¡Seeds mínimos para PDF completados!"