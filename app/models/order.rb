# app/models/order.rb
class Order < ApplicationRecord
  include ActionView::Helpers::NumberHelper # Para number_to_currency

  # --- ASOCIACIONES ---
  belongs_to :client, optional: true       # Asume que tienes un modelo Client y client_id en la tabla orders
  belongs_to :payment_method
  # belongs_to :employee, optional: true  # Si quieres asociar un empleado, añade employee_id a la tabla orders

  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products, allow_destroy: true

  # --- CONSTANTES Y ENUM PARA STATUS ---
  PENDING = 0
  PAID = 1
  PREPARING = 2 # Podrías necesitar un estado "en preparación"
  DELIVERED = 3 # O "Completado"
  VOID = 4      # "Anulado"

  # Ajusta los valores del enum para que coincidan con tus constantes
  enum status: { pendiente: PENDING, pagado: PAID, en_preparacion: PREPARING, entregado: DELIVERED, anulado: VOID }

  # --- ATRIBUTO VIRTUAL ---
  attr_accessor :skip_calculation # Para saltar el callback si es necesario

  # --- CALLBACKS ---
  # Es mejor calcular el total ANTES de guardar si es posible, o si es after_save, asegurar que no haya bucles.
  # Vamos a calcular el total en los seeds por ahora para simplificar, y puedes refinar este callback luego.
  # after_save :calculate_total_and_apply_discounts # Renombrado para claridad

  # --- MÉTODOS DE CLASE (Para Active Admin Search) ---
  def self.ransackable_attributes(auth_object = nil)
    # Asegúrate que estos campos existan en tu tabla 'orders'
    ["client_id", "created_at", "id", "payment_method_id", "status", "total", "updated_at", "employee_id", "order_date"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client", "employee", "order_products", "payment_method", "products"] # Añade asociaciones que quieras buscar
  end

  # --- MÉTODOS DE INSTANCIA ---

  # Este método `calculate` tenía un potencial bucle infinito con self.save.
  # Si necesitas esta lógica de descuento, debe manejarse con cuidado.
  # Por ahora, el `seeds.rb` calculará el total básico.
  # Si quieres mantener este cálculo complejo en el modelo, considera llamarlo explícitamente
  # o usar un `before_save` y asegurar que los datos estén listos.

  # def calculate_total_and_apply_discounts
  #   return if skip_calculation == true

  #   current_total = 0
  #   tacos_count = 0

  #   order_products.each do |op|
  #     # Asegúrate que op.price y op.units existan y sean correctos en OrderProduct
  #     # Y que op.product.price sea el precio unitario si op.price no lo es.
  #     # Asumiremos que op.price es el precio unitario de esa línea.
  #     line_total = (op.units || 0) * (op.price || 0) # Usamos || 0 por si son nil
  #     current_total += line_total

  #     # Necesitas un campo/método 'is_taco' en tu modelo Product
  #     if op.product && op.product.try(:is_taco)
  #       tacos_count += (op.units || 0)
  #     end
  #   end

  #   # Lógica de descuento para combos de tacos
  #   if tacos_count > 0
  #     combos = (tacos_count / 3.0).floor
  #     discount_for_combos = combos * 4000 # 4000 COP de descuento por cada 3 tacos
  #     current_total -= discount_for_combos
  #   end

  #   # Usar update_columns para evitar bucles de callbacks si actualizas desde un after_save
  #   # Esto actualiza la base de datos directamente.
  #   if self.total != current_total
  #     update_columns(total: current_total, updated_at: Time.current) # Actualiza también updated_at
  #   end
  # end


  # Los métodos init_product_holders, lines, format_product_line son para visualización/impresión.
  # Los dejaremos como están, pero asegúrate que funcionen con tus datos.
  # `Product.actives` en `init_product_holders` asume un scope `:actives` en el modelo Product.

  def init_product_holders
    # Considera si esta metaprogramación es realmente necesaria o si hay una forma más simple
    # de manejar los datos para tus vistas o lógica.
    Product.where(status: true).each do |product| # Asumiendo que Product tiene un status booleano para activo
      aux_name = product.name.parameterize.underscore # Forma más robusta de crear nombres de variable
      self.class.attr_accessor aux_name unless respond_to?("#{aux_name}=")
      instance_variable_set("@#{aux_name}", nil)
    end
  rescue ActiveRecord::StatementInvalid # Captura error si la tabla products no existe (ej. durante migraciones)
    # No hacer nada o loguear, para evitar que falle en ciertos contextos (como db:schema:load)
    Rails.logger.warn("Tabla 'products' no encontrada durante Order#init_product_holders. Omitiendo.")
  end

  def lines(include_totals=false)
    accent_mapping = {
      'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u',
      'Á' => 'A', 'É' => 'E', 'Í' => 'I', 'Ó' => 'O', 'Ú' => 'U',
      'ñ' => 'n', 'Ñ' => 'N', 'ü' => 'u', 'Ü' => 'U'
    }

    skip = " "*12 # Ajustado para alineación si es para impresora térmica (usualmente espacios)
    dash = "-"*20
    separator = "-"*32 # Ancho típico de ticket

    array = [
      "", # Espacios para empujar hacia abajo
      "",
      "      CHINGON TAQUERIA", # Centrado aproximado
      "       Manizales, Caldas", # Ciudad
      "     NIT: 123.456.789-0",   # Ejemplo de NIT
      "",
      "PEDIDO No: #{id}", # Número de pedido
      "FECHA: #{created_at.in_time_zone('America/Bogota').strftime("%Y-%m-%d %H:%M")}",
      # "CLIENTE: #{client.try(:name) || 'Varios'}", # Si tienes cliente
      # "ATENDIDO POR: #{employee.try(:name) || 'N/A'}", # Si tienes empleado
      separator
    ]

    order_products.each do |op|
      # Asegúrate que op.product exista
      product_name = op.product ? op.product.name.upcase : "PRODUCTO DESCONOCIDO"
      name_filtered = product_name.gsub(/[#{accent_mapping.keys.join}]/, accent_mapping)

      # Asumimos que op.units es la cantidad y op.price es el precio unitario de esa línea
      units_str = op.units.to_i.to_s # o op.units.to_s si puede ser decimal
      price_str = number_to_currency(op.price * op.units, precision: 0, unit: "$", separator: ",", delimiter: ".")

      array << format_product_line("#{op.units.to_i} #{name_filtered.truncate(18)}", price_str, 32)
    end
    array << separator

    if include_totals
      # El cálculo de total con descuento por combo de tacos se haría antes si se implementa
      # Aquí mostramos el total guardado en la orden.
      subtotal_orden = self.total # Este es el total ya calculado (posiblemente con descuentos)

      array << format_product_line("SUBTOTAL:", number_to_currency(subtotal_orden, precision: 0, unit: "$", separator: ",", delimiter: "."), 32)
      array << separator

      # Si quieres añadir servicio opcional
      # servicio_opcional_valor = subtotal_orden * 0.10
      # array << format_product_line("SERV. OPCIONAL(10%):", number_to_currency(servicio_opcional_valor, precision: 0, unit: "$", separator: ",", delimiter: "."), 32)
      # array << separator
      # total_con_servicio = subtotal_orden + servicio_opcional_valor
      # array << format_product_line("TOTAL A PAGAR:", number_to_currency(total_con_servicio, precision: 0, unit: "$", separator: ",", delimiter: "."), 32)

      array << format_product_line("TOTAL:", number_to_currency(subtotal_orden, precision: 0, unit: "$", separator: ",", delimiter: "."), 32) # Mostrando el total guardado
      array << separator
      array << ""
      array << "    GRACIAS POR SU COMPRA!"
      array << "       ¡VUELVA PRONTO!"
      array << ""
      array << ""
    end
    array
  end

  def format_product_line(item_text, value_text, line_width)
    # Calcula espacios necesarios entre el texto del item y el valor
    spaces_needed = line_width - item_text.length - value_text.length
    spaces = spaces_needed > 0 ? " " * spaces_needed : " " # Al menos un espacio si cabe
    "#{item_text}#{spaces}#{value_text}"
  end
end