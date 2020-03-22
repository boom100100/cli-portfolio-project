class Player
  attr_accessor :cards, :hand_value

  def initialize
    @cards = []
  end

  def hand_value
    value = @cards.select{|card| card.value}.reduce(0, :+)
  end
end
