# frozen_string_literal: true

require_relative './cart_item'

class CartItemScanner
  ITEM_LINE = /(\d+)([\w\s]+) at (.+)/.freeze

  class ScanError < StandardError
  end

  def self.scan(item, tax_rules = {})
    match = ITEM_LINE.match(item)

    if match.nil? || match.size != 4
      raise ScanError, "Couldn't scan cart item: #{item}"
    end

    quantity = match[1].to_i
    product = match[2].strip
    price = match[3].to_f

    # As soon as the application grows, the tax rules should exist in a separate
    # class. CartItemScanner would just delegate that responsibility to it.
    # I didn't want to implement it now because it felt like over engineering.
    taxes = []
    taxes << tax_rules.fetch(:basic, nil) unless /(chocolate|pill|book)/.match?(product)
    taxes << tax_rules.fetch(:import, nil) if product.include?('imported')

    CartItem.new(quantity: quantity,
                 product: product,
                 price: price,
                 taxes: taxes.compact)
  end
end
