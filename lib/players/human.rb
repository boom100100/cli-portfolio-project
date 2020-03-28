module Players
  class Human < Player
    attr_accessor :bet, :side_bet, :chips, :net_winnings

    def initialize
      super
      @chips = 500.00
      @bet = [0]
      @side_bet = 0
      @net_winnings = 0
    end


    def move(hand = nil) #bet <= chips ? bet = input : move
      input = gets.chomp
      input
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
