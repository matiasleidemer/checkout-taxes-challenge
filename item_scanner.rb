# frozen_string_literal: true

require_relative './cart_item'

class ItemScanner
  ITEM_LINE = /(\d+)([\w\s]+) at (.+)/.freeze

  def self.scan(item, tax_rules)
    match = ITEM_LINE.match(item)

    product = match[2].strip
    price = match[3].to_f
    quantity = match[1].to_i

    taxes = []
    taxes << tax_rules.fetch(:basic, nil) unless /(chocolate|pill|book)/.match?(product)
    taxes << tax_rules.fetch(:import, nil) if product.include?('imported')

    CartItem.new(quantity: quantity,
                 product: product,
                 price: price,
                 taxes: taxes.compact)
  end
end
