class Card
  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def present_card
    "#{value} of #{suit}"
  end
end
