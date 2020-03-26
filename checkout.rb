# frozen_string_literal: true

require_relative './product'
require_relative './cart_item'

class Checkout
  ITEM_SCANNER = /(\d+)([\w\s]+) at (.+)/.freeze

  TAX_RULES = {
    basic: { id: :basic, name: 'Basic salex tax', multiplier: 0.1 },
    import: { id: :import, name: 'Import duty', multiplier: 0.05 }
  }.freeze

  attr_reader :items, :tax_rules

  def initialize
    @items = []
  end

  def add(item)
    @items << scan(item)
  end

  def receipt
    items.map(&:to_s).tap do |lines|
      lines << "Sales Taxes: #{format('%.2f', taxes)}"
      lines << "Total: #{format('%.2f', total)}"
    end.join("\n") << "\n"
  end

  def taxes
    items.sum(&:tax)
  end

  def total
    items.sum(&:total_with_taxes)
  end

  private

  def scan(item)
    match = ITEM_SCANNER.match(item)

    product = Product.new(name: match[2].strip, price: match[3].to_f)
    quantity = match[1].to_i

    taxes = []
    taxes << TAX_RULES.fetch(:basic) unless /(chocolate|pill|book)/.match?(product.name)
    taxes << TAX_RULES.fetch(:import) if product.name.include?('imported')

    CartItem.new(quantity: quantity, product: product, taxes: taxes)
  end
end
