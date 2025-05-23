# Limpia tablas antes de insertar datos nuevos
Employee.destroy_all
PaymentMethod.destroy_all
Supplier.destroy_all
Product.destroy_all
Order.destroy_all
OrderProduct.destroy_all
Expense.destroy_all
Supply.destroy_all
SupplyInventory.destroy_all

# Empleados
Employee.create!([
  { name: "Juan Pérez", phone: "3001234567", email: "juan@chingon.com" },
  { name: "Luisa Gómez", phone: "3109876543", email: "luisa@chingon.com" }
])

# Métodos de pago
PaymentMethod.create!([
  { name: "Efectivo" },
  { name: "Tarjeta de crédito" },
  { name: "Transferencia" }
])

# Suplidores
Supplier.create!([
  { name: "Frutas El Paraíso", phone: "3123456789", email: "frutas@proveedor.com" },
  { name: "Carnes Don Lucho", phone: "3012345678", email: "carnes@proveedor.com" }
])

# Productos
Product.create!([
  { name: "Hamburguesa", price: 18000 },
  { name: "Salchipapa", price: 12000 },
  { name: "Perro Caliente", price: 10000 }
])

# Pedidos
order1 = Order.create!(status: 1, total: 30000) # status: 1 = pagado
order2 = Order.create!(status: 0, total: 18000) # status: 0 = pendiente

# Productos por pedido
OrderProduct.create!([
  { order: order1, product_id: Product.first.id, quantity: 1 },
  { order: order1, product_id: Product.last.id, quantity: 1 },
  { order: order2, product_id: Product.first.id, quantity: 1 }
])

# Gastos
Expense.create!([
  { supplier_id: Supplier.first.id, amount: 8000, description: "Compra de tomates" },
  { supplier_id: Supplier.last.id, amount: 20000, description: "Compra de carne" }
])

# Insumos
Supply.create!([
  { name: "Tomate", unit: "kg" },
  { name: "Pan", unit: "unidades" },
  { name: "Carne", unit: "kg" }
])

# Inventario de insumos
SupplyInventory.create!([
  { supply_id: Supply.first.id, quantity: 10 },
  { supply_id: Supply.last.id, quantity: 5 }
])