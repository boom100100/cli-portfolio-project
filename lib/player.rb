class Player
  attr_accessor :cards, :hand_value, :is_playing, :is_leaving

  def initialize
    @cards = []
    @is_playing = true
    @is_leaving = false
  end

  def hand_value
    value = 0
    @cards.each do |card|
      puts card[:value]
      secondary_value = 1 if card[:value] = 11
      value = value + card[:value]
      value = value - 10 if (secondary_value && value > 21)
    end

      value
  end
end
