class Player
  attr_accessor :hands, :cards, :hand_value, :is_playing, :is_leaving

  def initialize
    @hands = []
    @cards = [] #first hand
    @hands << @cards
    @is_playing = [true]
    @is_leaving = false
  end

  def hand_value(hand)
    value = 0
    secondary_value = []
    hand.each do |card|
      secondary_value << 1 if card[:value] == 11
      value = value + card[:value]

      while (secondary_value.length > 0 && value > 21)
        value = value - 10
        secondary_value.shift
      end
    end

    value
  end
end
