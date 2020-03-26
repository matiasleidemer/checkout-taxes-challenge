# frozen_string_literal: true

require_relative '../checkout'

RSpec.describe 'Checkout' do
  it 'returns the receipt for regular products' do
    checkout = Checkout.new
    checkout.add('2 book at 12.49')
    checkout.add('1 music CD at 14.99')
    checkout.add('1 chocolate bar at 0.85')

    output = <<~EOI
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    EOI

    expect(checkout.receipt).to eql(output)
  end

  it 'returns the receipt for imported products' do
    checkout = Checkout.new
    checkout.add('1 imported box of chocolates at 10.00')
    checkout.add('1 imported bottle of perfume at 47.50')

    output = <<~EOI
      1 imported box of chocolates: 10.50
      1 imported bottle of perfume: 54.65
      Sales Taxes: 7.65
      Total: 65.15
    EOI

    expect(checkout.receipt).to eql(output)
  end
end
