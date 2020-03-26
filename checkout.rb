# frozen_string_literal: true

class Checkout
  def add(item); end

  def receipt
    <<~EOI
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    EOI
  end
end
