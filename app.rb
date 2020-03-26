# frozen_string_literal: true

require_relative './checkout'

checkout = Checkout.new
input = File.open(ARGV[0], 'r')

input.each_line do |line|
  checkout.add(line)
end

input.close

puts checkout.receipt
