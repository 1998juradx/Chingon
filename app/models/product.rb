class Product < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "price", "status", "updated_at"]
  end

  has_many :product_supplies, dependent: :destroy
  has_many :supplies, through: :product_supplies

  has_many :order_products, dependent: :nullify

  validates :name, presence: true
  validates :name, uniqueness: true

  accepts_nested_attributes_for :product_supplies, allow_destroy: true

  enum position: { 
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "11" => 11,
    "12" => 12,
    "13" => 13,
    "14" => 14,
    "15" => 15,
    "16" => 16,
    "17" => 17,
    "18" => 18,
    "19" => 19,
    "20" => 20,
    "21" => 21,
    "22" => 22,
    "23" => 23,
    "24" => 24,
    "25" => 25,
    "26" => 26,
    "27" => 27,
    "28" => 28,
    "29" => 29,
    "30" => 30,
  }

end
