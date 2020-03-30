# frozen_string_literal: true

class TaxSelector
  attr_reader :tax_rules

  def initialize(tax_rules)
    @tax_rules = tax_rules
  end

  def map_taxes(product)
    [].tap do |taxes|
      taxes << tax_rules.fetch(:basic, nil) unless /(chocolate|pill|book)/.match?(product)
      taxes << tax_rules.fetch(:import, nil) if product.include?('imported')
    end.compact
  end
end
