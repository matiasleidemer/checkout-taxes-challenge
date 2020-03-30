# frozen_string_literal: true

require_relative './cart_item'

class CartItemScanner
  ITEM_LINE = /(\d+)([\w\s]+) at (.+)/.freeze

  class ScanError < StandardError
  end

  def self.scan(item, _tax_rules = {})
    match = ITEM_LINE.match(item)

    raise ScanError, "Couldn't scan cart item: #{item}" if match&.size != 4

    quantity = match[1].to_i
    product = match[2].strip
    price = match[3].to_f

    CartItem.new(quantity: quantity, product: product, price: price)
  end
end
