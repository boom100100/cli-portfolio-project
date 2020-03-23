class Player
  attr_accessor :cards, :hand_value

  def initialize
    @cards = []
  end

  def hand_value
    @cards.reduce {|acc, h| acc.merge(h) {|_,v1,v2| v1 + v2 }}[:value]
  end
end
