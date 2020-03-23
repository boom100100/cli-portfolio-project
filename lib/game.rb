class Game
  attr_accessor :deck, :player_1, :player_2, :player_3, :house
  attr_reader :players

  def initialize(deck = nil, house = nil, p1 = nil, p2 = nil, p3 = nil)
    @deck = Deck.new unless @deck = deck

    @house = Players::House.new unless @house = house
    @player_1 = Players::Human.new unless @player_1 = p1
    @player_2 = Players::Computer.new
    @player_3 = Players::Computer.new

    @players = []
    @players << @player_1
    @players << @player_2
    @players << @player_3
  end

  def self.tutorial
    puts 'The object of the game is to beat the dealer.'
    puts 'Gameplay works as follows.'
    puts 'Place an initial bet.'
    #puts 'Choose whether to increase that bet.'
    puts 'The dealer deals cards after the first bet.'
    puts 'If no player immediately gets a blackjack, you can choose to draw another card into your hand or to decline.'
    puts 'Stop when you have the highest possible value without not going over, or "busting."'
    puts ''
    puts 'Cards 2-10 are worth their numerical value, regardless of suit.'
    puts 'Cards J, Q and K are worth 10.'
    puts 'An A (or ace) is worth 11 or 1 point, depending on your need.'
    puts 'For example, having an A and a J means you have a blackjack hand. Your score is 21, and if you are the only one with two cards like these, you automatically win. If the dealer also has this hand, it is a tie between you two.'
    puts 'Alternatively, an A, a 10, a 7, and a 3 also add to 21.'
    puts 'Now, let\'s jump in!'
    puts ''
    puts ''
  end

  def self.strategy
    puts 'Counting cards is the best way to beat the house.'
    puts 'To do so, assign a value to all cards on the table.'
    puts 'Assign +1 to 2-6, 0 to 7-9, and -1 to 10-A.'
    puts 'Keep track of those secondary values and add them together as the game progresses.'
    puts 'This is called the running count.'
    puts 'Many blackjack tables use multiple decks to thwart this method of card counting.'
    puts 'If there are multiple decks, you must make a small adjustment to the running count to calculate the true count.'
    puts 'The true count is the running count divided by the number of decks remaining.'
    puts 'If there is just one deck, the running count is equal to the true count.'
    puts 'From there, if the true count remains in the positive, the dealer of the house has a greater chance of busting. If the true count is negative, the house has the advantage.'
    puts ''
    puts ''
  end

  def start
    puts "Place your bets!"
    puts ''
    puts ''
    choose_table
    place_bet
    deal
    insurance
    play

    #place bets
    #deal
    #reveal natural winnings


    #if game.deck.cards = 0 puts "I'm opening a new deck."
  end

  def choose_table
    input = nil

    puts 'Please choose a table.'
    i = 0
    loop do
      i += 1
      puts "Enter #{i} for Table #{i}. This table has #{i} deck(s)."
      break if i == 8
    end
    input = @player_1.move
    if input.to_i > 8 || input.to_i <= 0
      choose_table
    end
    puts "You have chosen Table #{input}"
    @deck.make_decks(input.to_i)
    input
  end

  def bet(player)
    if player.is_a? Players::Human
      puts "Please enter a value for your bet. You have #{player.chips} chips."
      wager = player.move
      if wager.to_i && wager.to_i <= player.chips && wager.to_i > 0 #bets just enough
        player.bet = wager
      elsif wager.to_i && wager.to_i > player.chips #bets too much
        puts "You don't have enough chips for that wager."
        bet(player)
      elsif wager.to_i #bets too little
        puts 'You have decided to sit this round out.'
      else
        puts 'Invalid input.'
      end
    else
      player.bet = 100
      puts "The computer bets #{player.bet}."
    end
  end

  def place_bet
    @players.each do |player|
      bet(player)
    end
  end

  def deal
  end
  def insurance
  end
  def play
  end

  def do_turn
  end #play 1. all players place a bet. 2. one face up card clockwise, including one to dealer. 3. one more face up to each, except to dealer. Dealer's second card is face down. 4. If dealer has ace, insurance bet offer. 5. If non-dealer has natural, player receives 1.5 of bet. If only dealer has natural, all other players lose bet. If there is a natural tie between dealer and player,



  def hit(player) #gives card to player, removes card from @cards
  end

  def reveal
    @house.cards
     #write to show house's cards
  end

  def draw?
    @player_1.hand_value == @house.hand_value
  end

  def won?
    @player_1.hand_value > @house.hand_value
=begin
  How do you beat the dealer?
  #By drawing a hand value that is higher than the dealer’s hand value
  #By the dealer drawing a hand value that goes over 21.
  #By drawing a hand value of 21 on your first two cards, when the dealer does not.

  How do you lose to the dealer?
  #Your hand value exceeds 21.
  #The dealers hand has a greater value than yours at the end of the round
=end
  end

  def over? #when you walk away or when chips = 0 or when you get kicked out because house is angry100
  end
  def winner
  end
end
