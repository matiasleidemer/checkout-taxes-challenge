
class TaxRule
  attr_reader :id, :name, :multiplier

  def initialize(id:, :multiplier)
    @id = id
    @multiplier = multiplier
  end
end
