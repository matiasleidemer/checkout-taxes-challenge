# frozen_string_literal: true

module TaxRules
  class Basic
    attr_reader :name, :multiplier

    def initialize(name, multiplier)
      @name = name
      @multiplier = multiplier
    end

    def apply?(cart_item)
      !/(chocolate|pill|book)/.match?(cart_item.product)
    end
  end
end
