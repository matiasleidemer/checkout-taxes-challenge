# frozen_string_literal: true

require_relative './cart_item_scanner'
require_relative './tax_calculator'
require_relative './tax_rules/basic'
require_relative './tax_rules/imported'

class Checkout
  # Right now, it's fine to leave Checkout with the TaxRule knowledge since the
  # application is so small. Ideally, Checkout and TaxRule should be decoupled
  # from each other.
  # Checkout instances can have their own set of tax rules based on the given
  # context. For instance, the checkout process in Brazil has different tax
  # rules from a checkout in the USA.
  TAX_RULES = [
    TaxRules::Basic.new('Basic sales tax', 0.1),
    TaxRules::Imported.new('Import duty', 0.05)
  ].freeze

  attr_reader :items, :tax_rules

  def initialize(tax_rules: TAX_RULES)
    @items = []
    @tax_rules = tax_rules
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
    items.map { |item| TaxCalculator.item_with_taxes(item, tax_rules) }
  end

  def sale_taxes
    items_with_taxes.sum(&:total) - items.sum(&:total)
  end

  def total
    items_with_taxes.sum(&:total)
  end
end
