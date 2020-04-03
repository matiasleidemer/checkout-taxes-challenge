# frozen_string_literal: true

module TaxRules
  class Imported
    attr_reader :name, :multiplier

    def initialize(name, multiplier)
      @name = name
      @multiplier = multiplier
    end

    def apply?(cart_item)
      cart_item.product.include?('imported')
    end
  end
end
