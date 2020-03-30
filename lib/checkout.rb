# frozen_string_literal: true

require_relative './cart_item_scanner'
require_relative './tax_selector'
require_relative './tax_calculator'

class Checkout
  # Right now, it's fine to leave Checkout with the TaxRule knowledge since the
  # application is so small. Ideally, Checkout and TaxRule should be decoupled
  # from each other.
  # Checkout instances can have their own set of tax rules based on the given
  # context. For instance, the checkout process in Brazil has different tax
  # rules from a checkout in the USA.
  TaxRule = Struct.new(:id, :name, :multiplier)

  TAX_RULES = {
    basic: TaxRule.new(:basic, 'Basic sales tax', 0.1),
    import: TaxRule.new(:import, 'Import duty', 0.05)
  }.freeze

  attr_reader :items, :tax_rules

  def initialize(tax_rules: TAX_RULES)
    @items = []
    @tax_rules = TaxSelector.new(tax_rules)
  end

  def add(item)
    @items << CartItemScanner.scan(item)
  end

  def receipt
    lines = items_with_taxes.map(&:to_s)
    lines << "Sales Taxes: #{format('%.2f', sale_taxes)}"
    lines << "Total: #{format('%.2f', total)}"
    lines.join("\n") << "\n"
  end

  private

  def items_with_taxes
    items.map do |item|
      taxes = tax_rules.map_taxes(item.product)
      TaxCalculator.item_with_taxes(item, taxes)
    end
  end

  def sale_taxes
    items_with_taxes.sum(&:total) - items.sum(&:total)
  end

  def total
    items_with_taxes.sum(&:total)
  end
end
