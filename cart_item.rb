# frozen_string_literal: true

class CartItem
  attr_reader :quantity, :product, :price, :taxes

  def initialize(quantity:, product:, price:, taxes:)
    @quantity = quantity
    @product = product
    @price = price
    @taxes = taxes
  end

  def to_s
    "#{quantity} #{product}: #{format('%.2f', total_with_taxes)}"
  end

  def sale_taxes
    total_with_taxes - total
  end

  def total_with_taxes
    (price_with_taxes * quantity).round(2)
  end

  private

  def price_with_taxes
    return price unless taxes.any?

    taxes.inject(0) do |total_tax, tax|
      total_tax += (price * tax.multiplier).round(2)
      total_tax += 0.01 while (total_tax / 0.05).round(2) % 1 != 0
      total_tax
    end + price
  end

  def total
    (price * quantity).round(2)
  end
end
