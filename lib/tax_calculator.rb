# frozen_string_literal: true

class TaxCalculator
  def self.item_with_taxes(cart_item, tax_rules)
    taxes = tax_rules.select { |tr| tr.apply?(cart_item) }

    tax = taxes.reduce(0) do |total_tax, tax_rule|
      total_tax += (cart_item.price * tax_rule.multiplier).round(2)
      total_tax += 0.01 while (total_tax / 0.05).round(2) % 1 != 0
      total_tax
    end

    CartItem.new(quantity: cart_item.quantity,
                 product: cart_item.product,
                 price: cart_item.price + tax)
  end
end
