module Players
  class Computer < Player
    attr_accessor :bet, :side_bet, :chips

    def initialize
      super
      @chips = 500.00
      @bet = [0]
      @side_bet = 0
    end
    def move(hand = @cards)
      input = strategy(hand)
      input
    end

    def strategy(hand)
      hand_value(hand) >= 17 ? "1" : "2" #1 is stand; 2 is hit
    end

    def bet=(value, hand_index = 0)
      if @bet[hand_index]
         @bet[hand_index] = value
       else
         @bet << value
       end
    end
  end
end
