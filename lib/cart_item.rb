# frozen_string_literal: true

class CartItem
  attr_reader :quantity, :product, :price, :taxes

  def initialize(quantity:, product:, price:)
    @quantity = quantity
    @product = product
    @price = price
  end

  def to_s
    "#{quantity} #{product}: #{format('%.2f', total)}"
  end

  def total
    (price * quantity).round(2)
  end
end
