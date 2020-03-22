module Players
  class House < Player
    attr_accessor :anger

    def initialize
      @anger = 0 #if anger = 100, player_1 gets kicked out. This resets whole game. Condition will change as player_1 wins - other players don't matter
    end

    def move
      input = gets
      input
    end
    
  end
end
