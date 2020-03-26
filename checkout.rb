# frozen_string_literal: true

require_relative './product'

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

  Item = Struct.new(:quantity, :product, :taxes) do
    def tax
      total_with_taxes - total
    end

    def price_with_taxes
      return price unless taxes.any?

      taxes.inject(0) do |total_tax, tax|
        total_tax += (price * tax[:multiplier]).round(2)
        total_tax += 0.01 while (total_tax / 0.05).round(2) % 1 != 0
        total_tax
      end + price
    end

    def price
      product.price
    end

    def total
      (price * quantity).round(2)
    end

    def total_with_taxes
      (price_with_taxes * quantity).round(2)
    end

    def to_s
      "#{quantity} #{product.name}: #{format('%.2f', total_with_taxes)}"
    end
  end

  def scan(item)
    match = ITEM_SCANNER.match(item)

    product = Product.new(name: match[2].strip, price: match[3].to_f)
    quantity = match[1].to_i

    taxes = []
    taxes << TAX_RULES.fetch(:basic) unless /(chocolate|pill|book)/.match?(product.name)
    taxes << TAX_RULES.fetch(:import) if product.name.include?('imported')

    Item.new(quantity, product, taxes)
  end
end
