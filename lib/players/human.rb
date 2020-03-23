module Players
  class Human < Player
    attr_accessor :bet, :chips, :net_winnings

    def initialize
      @chips = 500
      @bet = 0
      @net_winnings = 0
    end


    def move #bet <= chips ? bet = input : move
      input = gets.chomp
      input
    end
  end
end
