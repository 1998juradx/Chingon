class Order < ApplicationRecord


  include ActionView::Helpers::NumberHelper

  def self.ransackable_attributes(auth_object = nil)
    ["client_id", "created_at", "id", "payment_method_id", "status", "total", "updated_at"]
  end
  belongs_to :client, optional: true
  belongs_to :payment_method
  
  has_many :order_products, dependent: :destroy
  
  PENDING = 0
  PAID = 1
  DELIVERED = 2
  VOID = 3
  
  attr_accessor :skip_calculation
  
  enum status: { pendiente: PENDING, pagado: PAID, entregado: DELIVERED, anulado: VOID }
  
  accepts_nested_attributes_for :order_products, allow_destroy: true
  
  after_save :calculate
  
  def calculate
    
    return if self.skip_calculation == true

    self.total = 0
    tacos = 0
    
    self.order_products.each do |op|
      
      self.total += op.price * op.units
      tacos += op.units if op.product.is_taco
      
    end
    
    combos = (tacos / 3.0).floor
    
    self.total -= (combos * 4000)
    
    self.skip_calculation = true

    self.save
  end
  
  def init_product_holders
    Product.actives.each do |product|
      # Create an instance variable for the attribute
      aux_name = product.name.gsub("-", "_").gsub(" ", "_")
      self.class.attr_accessor aux_name
      instance_variable_set("@#{aux_name}", nil)
      
      # # Define getter method
      # define_singleton_method(key) do
      #   instance_variable_get("@#{key}")
      # end
      
      # # Define setter method
      # define_singleton_method("#{key}=") do |new_value|
      #   instance_variable_set("@#{key}", new_value)
      # end
    end
  end

  def lines(include_totals=false)

    accent_mapping = {
      'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u',
      'Á' => 'A', 'É' => 'E', 'Í' => 'I', 'Ó' => 'O', 'Ú' => 'U',
      'ñ' => 'n', 'Ñ' => 'N', 'ü' => 'u', 'Ü' => 'U'
    }

    skip = "-"*12
    dash = "-"*20
    separator = "-"*22

    
    array = [
      "","","","","",

      "#{skip}CHINGON TAQUERIA-----",
      "",
      separator
    ] 
    
    self.order_products.each do |op|
      name_filtered = op.product.name.upcase.gsub(/[#{accent_mapping.keys.join}]/, accent_mapping)
      array << "#{skip}#{format_product_line(name_filtered, op.units.to_i.to_s)}"
      array << separator
    end
    if include_totals
      array << ""
      array << "#{skip}#{format_product_line("SUBTOTAL", (number_to_currency self.total, precision: 0, unit: "$"))}"
      array << separator
      array << ""
      array << "#{skip}#{format_product_line("SERVICIO OPCIONAL", "")}"
      array << "#{skip}#{format_product_line("(10%)", (number_to_currency self.total * 0.1, precision: 0, unit: "$"))}"
      array << separator
      array << "#{skip}#{format_product_line("TOTAL", (number_to_currency self.total + (self.total * 0.1), precision: 0, unit: "$"))}"
      array << separator
      array << ""
      array << ""
      array << ""
      array << "#{skip}#{self.created_at.in_time_zone.strftime("%Y-%m-%d %H:%M")}"
      array << ""
      array << ""
    else
      array << ""
      array << ""
      array << ""
    end
  end

  def format_product_line(product_name, units)
    # Calculate the length of the product line after adding the product name and units
    line_length = product_name.length + units.length
    
    # Calculate the number of hyphens needed to fill the remaining space
    remaining_space = 20 - line_length
    
    # Pad the product name with hyphens to make the line 18 characters long
    formatted_line = product_name + "-" * remaining_space + units
    
    return formatted_line
  end
end