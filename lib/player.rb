class Player
  attr_accessor :cards, :hand_value, :is_playing, :is_leaving

  def initialize
    @cards = []
    @is_playing = true
    @is_leaving = false
  end

  def hand_value
    value = 0
    secondary_value = []
    @cards.each do |card|
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
