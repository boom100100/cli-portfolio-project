module Players
  class Computer < Player
    attr_accessor :bet, :side_bet, :chips

    def initialize
      super
      @chips = 500
      @bet = 0
      @side_bet = 0
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
