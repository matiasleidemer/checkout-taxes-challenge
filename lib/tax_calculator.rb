# frozen_string_literal: true

class TaxCalculator
  def self.item_with_taxes(cart_item, rules)
    taxes = []
    taxes << rules.fetch(:basic, nil) unless /(chocolate|pill|book)/.match?(cart_item.product)
    taxes << rules.fetch(:import, nil) if cart_item.product.include?('imported')

    price = if taxes.any?
              taxes.inject(0) do |total_tax, tax|
                total_tax += (cart_item.price * tax.multiplier).round(2)
                total_tax += 0.01 while (total_tax / 0.05).round(2) % 1 != 0
                total_tax
              end + cart_item.price
            else
              cart_item.price
            end

    CartItem.new(quantity: cart_item.quantity,
                 product: cart_item.product,
                 price: price)
  end
end
