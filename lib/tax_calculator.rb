# frozen_string_literal: true

class TaxCalculator
  def self.item_with_taxes(cart_item, taxes = [])
    price_tax =
      taxes.inject(0) do |total_tax, tax|
        total_tax += (cart_item.price * tax.multiplier).round(2)
        total_tax += 0.01 while (total_tax / 0.05).round(2) % 1 != 0
        total_tax
      end

    CartItem.new(quantity: cart_item.quantity,
                 product: cart_item.product,
                 price: cart_item.price + price_tax)
  end
end
