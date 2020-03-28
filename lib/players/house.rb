module Players
  class House < Player
    attr_accessor :angry

    def initialize
      super
      @angry = false #if anger = 100, player_1 gets kicked out. This resets whole game. Condition will change as player_1 wins - other players don't matter
    end

    def move(hand = @cards)
      input = strategy(hand)
      input
    end

    def strategy(hand)
      hand_value(hand) >= 17 ? "1" : "2" #1 is stand; 2 is hit
    end

  end
end
