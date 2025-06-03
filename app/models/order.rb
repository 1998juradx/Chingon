# app/models/order.rb
class Order < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :client, optional: true
  belongs_to :payment_method
  belongs_to :employee, optional: true

  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products, allow_destroy: true

  PENDING = 0
  PAID = 1
  PREPARING = 2
  DELIVERED = 3
  VOID = 4

  enum status: { pendiente: PENDING, pagado: PAID, en_preparacion: PREPARING, entregado: DELIVERED, anulado: VOID }

  attr_accessor :skip_calculation

  validates :client_name,
            length: { maximum: 100, too_long: "El nombre manual del cliente no puede tener más de %{count} caracteres." },
            format: { 
              with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑ\s'-]*\z/,
              message: "El nombre manual del cliente solo puede contener letras, espacios, apóstrofes o guiones." 
            },
            allow_blank: true

  validates :status, presence: { message: "Debe seleccionar un estado para el pedido." }
  validates :payment_method, presence: { message: "Debe seleccionar un método de pago." }
  validates :total, 
            presence: { message: "El total del pedido no puede estar vacío." },
            numericality: { 
              greater_than_or_equal_to: 0, 
              message: "El monto total debe ser un número mayor o igual a cero." 
            }
  # validates :order_date, presence: { message: "La fecha del pedido es obligatoria." } # Descomenta si es un campo requerido y existe
  # validates :order_products, presence: { message: "El pedido debe tener al menos un producto." } # Validación más avanzada

  # before_save :calculate_total_and_apply_discounts, unless: :skip_calculation

  def self.ransackable_attributes(auth_object = nil)
    ["client_id", "client_name", "created_at", "id", "payment_method_id", "status", "total", "updated_at", "employee_id", "order_date"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["client", "employee", "order_products", "payment_method", "products"]
  end

  # def calculate_total_and_apply_discounts
  #   current_total = 0
  #   tacos_count = 0
  #   self.order_products.reload.each do |op|
  #     line_total = (op.units.to_f || 0) * (op.price.to_f || 0)
  #     current_total += line_total
  #     if op.product && op.product.try(:is_taco)
  #       tacos_count += (op.units.to_f || 0)
  #     end
  #   end
  #   if tacos_count > 0
  #     combos = (tacos_count / 3.0).floor
  #     discount_for_combos = combos * 4000
  #     current_total -= discount_for_combos
  #   end
  #   self.total = current_total.round(2)
  # end

  def init_product_holders
    return unless ActiveRecord::Base.connection.table_exists? 'products'
    Product.where(status: true).each do |product|
      aux_name = product.name.parameterize.underscore
      self.class.attr_accessor aux_name unless respond_to?("#{aux_name}=")
      instance_variable_set("@#{aux_name}", nil)
    end
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.warn("Tabla 'products' no encontrada durante Order#init_product_holders: #{e.message}")
  end

  def lines(include_totals=false)
    accent_mapping = {
      'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u',
      'Á' => 'A', 'É' => 'E', 'Í' => 'I', 'Ó' => 'O', 'Ú' => 'U',
      'ñ' => 'n', 'Ñ' => 'N', 'ü' => 'u', 'Ü' => 'U'
    }
    separator = "-"*32

    array = [
      "", "",
      "      CHINGON TAQUERIA",
      "       Manizales, Caldas",
      "     NIT: Tu-NIT-Aqui",
      "",
      "PEDIDO No: #{id}",
      "FECHA: #{created_at.in_time_zone('America/Bogota').strftime("%Y-%m-%d %H:%M")}",
      "CLIENTE: #{client.try(:name) || client_name.presence || 'Varios'}",
      "ATENDIDO POR: #{employee.try(:name) || 'N/A'}", # Asume que tienes la asociación :employee
      separator
    ]

    order_products.each do |op|
      product_name = op.product ? op.product.name.upcase : "PRODUCTO DESCONOCIDO"
      name_filtered = product_name.gsub(/[#{accent_mapping.keys.join}]/, accent_mapping)
      units_for_line = op.units.to_f || 0
      price_for_line = op.price.to_f || 0 # Asume que OrderProduct tiene 'price' como precio unitario
      line_total_val = units_for_line * price_for_line
      units_display_str = units_for_line.to_i.to_s
      price_display_str = number_to_currency(line_total_val, unit: "$", separator: ",", delimiter: ".", precision: 0)
      array << format_product_line("#{units_display_str} #{name_filtered.truncate(18)}", price_display_str, 32)
    end
    array << separator

    if include_totals
      subtotal_orden = self.total || 0
      array << format_product_line("SUBTOTAL:", number_to_currency(subtotal_orden, unit: "$", separator: ",", delimiter: ".", precision: 0), 32)
      array << separator
      array << format_product_line("TOTAL:", number_to_currency(subtotal_orden, unit: "$", separator: ",", delimiter: ".", precision: 0), 32)
      array << separator
      array << ""
      array << "    PEDIDO REALIZADO CORRECTAMENTE"
      array << "              ¡GRACIAS!"
      array << ""
    end
    array
  end

  def format_product_line(item_text, value_text, line_width)
    spaces_needed = line_width - item_text.length - value_text.length
    spaces = spaces_needed > 0 ? " " * spaces_needed : " "
    "#{item_text}#{spaces}#{value_text}"
  end
end