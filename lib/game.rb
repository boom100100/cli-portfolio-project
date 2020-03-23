class Game
  attr_accessor :deck, :player_1, :player_2, :player_3, :house
  attr_reader :betters, :players

  def initialize(deck = nil, house = nil, p1 = nil, p2 = nil, p3 = nil)
    @deck = Deck.new unless @deck = deck

    @house = Players::House.new unless @house = house
    @player_1 = Players::Human.new unless @player_1 = p1
    @player_2 = Players::Computer.new
    @player_3 = Players::Computer.new

    @betters = []
    @players = []
    @betters << @player_1
    @betters << @player_2
    @betters << @player_3
    @players = [*@betters, @host]
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
    puts ''
    puts 'You chose to start a new game.'
    choose_table #TODO needs test
    #while !over?
      place_bet #TODO needs test
      deal
      insurance
      play
    #end

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

  def bet(player, limit, type)
    if player.is_a? Players::Human
      puts "Please enter a value for your bet. You can bet between 5 and #{limit} chip(s)."
      wager = player.move
      if wager.to_i && wager.to_i <= limit && wager.to_i >= 5 #bets just enough
        player.send("#{type}=",wager.to_i)
        #player.bet = wager.to_i
        player.chips = player.chips - player.bet
        puts "Your bet is #{player.bet} chips."
      elsif wager.to_i && wager.to_i > limit #bets too much
        puts "That wager exceeds what you can bet."
        bet(player, limit, type)
      elsif wager.to_i != "0" && wager.to_i == 0
        puts 'Invalid input.'
        bet(player, limit, type)
      elsif wager.to_i && wager.to_i < 5 #bets too little
        puts "You can not bet fewer than 5 chips."
        bet(player, limit, type)

      end
    else
      player.bet = Random.new.rand(player.chips)
      puts "The computer bets #{player.bet}."
    end
  end

  def place_bet
    @betters.each do |player|
      bet(player, player.chips, 'bet')
    end
  end

  def deal
    @betters.each do |player|
      2.times { hit(player) }
      puts "This #{player.class} Player has the following cards:"
      player.cards.each do |card|
        reveal_card(card)
      end
    end
    2.times { hit(@house) }
    puts "The house's hand has one face-up card:"
    reveal_card(@house.cards[0])
  end

  def insurance
    if @house.cards[0][:value] == 11
      @betters.each do |player|
        if player.is_a? Players::Human
          puts 'Would you like insurance? (y/N)'
          input = gets.chomp
          if input == "y" || input == "Y"
            bet(player, (player.bet/2), 'side_bet')
          else
            puts 'Your input is invalid.'
            insurance
          end
        else
          bet(player, (player.bet/2), 'side_bet')
        end
      end
      distribute_winnings if over?
    end
  end

  def play
    @players.each do |player|
      do_turn(player)
    end
  end

  def do_turn(player)
    playing = true
    while playing
      puts "#{player}, what would you like to do?"
      puts "Stand (1), hit (2), double (3), split (4), or surrender (5)?"
      input = player.move
      case input
      when '1'
        playing = false
      when '2'
        hit(player)
        playing = false if player.hand_value >= 21
      when '3'
        double
      when '4'
        split
      when '5'
        surrender
        playing = false
      else
        puts 'That is an invalid move.'
        do_turn(player)
      end
    end

  end #play 1. all players place a bet. 2. one face up card clockwise, including one to dealer. 3. one more face up to each, except to dealer. Dealer's second card is face down. 4. If dealer has ace, insurance bet offer. 5. If non-dealer has natural, player receives 1.5 of bet. If only dealer has natural, all other players lose bet. If there is a natural tie between dealer and player,

  def hit(player) #gives card to player, removes card from @cards
    player.cards << @deck.cards.shift
  end

  def double
  end
  def split
  end
  def surrender
  end

  def reveal_card(card)
    puts Deck.interpret(card)
  end



  def won?
    #sc1: p1 has blackjack, house does not
    #sc2: 21 >= p1 hand > house
    (@player_1.hand_value > @house.hand_value && @player_1.hand_value <= 21) || @house.hand_value > 21 && @player_1.hand_value <= 21
  end

  def quit? #when you walk away or when chips = 0 or when you get kicked out because house is angry100
  end

  def over?
    #blackjack = over
    @players.each do |player|
      return blackjack?(player) if blackjack?(player)
    end

    if f
    end
  end

  def blackjack?(player)
    true if player.hand_value == 21 && player.cards.length == 2
  end

  def bust?(player) #can't draw more cards
    player.hand_value > 21
  end

  def draw?
    @player_1.hand_value == @house.hand_value
  end

  def distribute_winnings
    @betters.each do |player|
      if blackjack?(@house) && blackjack?(player) #draw + insurance winnings
        player.chips = player.chips + player.side_bet + player.bet
      elsif blackjack?(@house) #loss with side_bet
        player.chips = player.chips + player.side_bet
      end
    end
  end
end
