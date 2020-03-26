# frozen_string_literal: true

require_relative './product'
require_relative './cart_item'

class ItemScanner
  ITEM_LINE = /(\d+)([\w\s]+) at (.+)/.freeze

  def self.scan(item, tax_rules)
    match = ITEM_LINE.match(item)

    product = Product.new(name: match[2].strip, price: match[3].to_f)
    quantity = match[1].to_i

    taxes = []
    taxes << tax_rules.fetch(:basic, nil) unless /(chocolate|pill|book)/.match?(product.name)
    taxes << tax_rules.fetch(:import, nil) if product.name.include?('imported')

    CartItem.new(quantity: quantity, product: product, taxes: taxes.compact)
  end
end
