module Players
  class House < Player
    attr_accessor :anger

    def initialize
      super
      @anger = 0 #if anger = 100, player_1 gets kicked out. This resets whole game. Condition will change as player_1 wins - other players don't matter
    end

    def move
      input = strategy
      input
    end

    def strategy
      hand_value < 18 ? "y" : "n"
    end

  end
end
