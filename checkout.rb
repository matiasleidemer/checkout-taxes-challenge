# frozen_string_literal: true

require_relative './item_scanner'

class Checkout
  TAX_RULES = {
    basic: { id: :basic, name: 'Basic salex tax', multiplier: 0.1 },
    import: { id: :import, name: 'Import duty', multiplier: 0.05 }
  }.freeze

  attr_reader :items, :tax_rules

  def initialize
    @items = []
  end

  def add(item)
    @items << ItemScanner.scan(item, TAX_RULES)
  end

  def receipt
    lines = items.map(&:to_s)
    lines << "Sales Taxes: #{format('%.2f', taxes)}"
    lines << "Total: #{format('%.2f', total)}"
    lines.join("\n") << "\n"
  end

  def taxes
    items.sum(&:tax)
  end

  def total
    items.sum(&:total_with_taxes)
  end
end
