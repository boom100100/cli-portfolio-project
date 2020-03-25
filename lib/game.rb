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
    @players = [*@betters, @house]
  end

  def self.tutorial
    puts 'The object of the game is to beat the dealer.'
    puts ''
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
    puts ''
    change_table



    #if game.deck.cards = 0 puts "I'm opening a new deck."
  end

  def change_table
    choose_table #TODO needs test
    do_round
  end

  def do_round
    place_bet #TODO needs test
    deal
    insurance
    if over?
      distribute_winnings
      contemplate
    end
    play
    contemplate

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
    puts ''
    puts "You have chosen Table #{input}"
    puts ''
    @deck.make_decks(input.to_i)
    input
  end

  def bet(player, limit, type)
    minimum = 5
    if type == 'side_bet'
      minimum = 0
    end

    if player.is_a? Players::Human
      puts ''
      puts "Please enter a value for your bet."
      puts "You can bet between #{minimum} and #{limit} chip(s)."

      wager = player.move

        if wager.to_i && wager.to_i <= limit && wager.to_i >= minimum #bets just enough
          player.send("#{type}=",wager.to_i)
          #player.bet = wager.to_i
          player.chips = player.chips - player.send("#{type}")
          puts ''
          puts "Your bet is #{player.send("#{type}")} chips."
        elsif wager.to_i && wager.to_i > limit #bets too much
          puts "That wager exceeds what you can bet."
          bet(player, limit, type)
        elsif wager.to_i != "0" && wager.to_i == 0
          puts 'Invalid input.'
          bet(player, limit, type)
        elsif wager.to_i && wager.to_i < minimum #bets too little
          puts "You can not bet fewer than #{minimum} chip(s)."
          bet(player, limit, type)

        end

    else
      if player.chips >= limit
        player.send("#{type}=",Random.new.rand(limit))
        player.chips = player.chips - player.send("#{type}")
      else
        player.send("#{type}=",Random.new.rand(player.chips))
        player.chips = player.chips - player.bet
      end
      puts "The computer bets #{player.send("#{type}")}."
    end
  end

  def place_bet
    @betters.each do |player|
      bet(player, player.chips, 'bet')
    end
  end

  def deal
    @betters.each do |player|
      puts ''
      2.times { hit(player) }
      puts "This #{player.class} Player has the following cards:"
      player.cards.each do |card|
        reveal_card(card)
      end
    end
    2.times { hit(@house) }
    puts ''
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
          elsif input == "n" || input == "N"
          else
            puts 'Your input is invalid.'
            insurance
          end
        else
          bet(player, (player.bet/2), 'side_bet')
        end
      end
    end

  end

  def play
    @players.each do |player|
      do_turn(player)
    end
    distribute_winnings
  end

  def do_turn(player)
    playing = true
    while playing
      puts ''
      puts "#{player}, what would you like to do?"
      puts "Stand (1), hit (2), double (3), split (4), or surrender (5)?"
      input = player.move
      case input
      when '1'
        puts "#{player} has chosen to stand."
        playing = false
      when '2'
        puts "#{player} has chosen to hit."
        hit(player)
        puts ''
        puts 'Your cards are:'
        player.cards.each do |card|
          puts "#{Deck.interpret(card)}"
        end
        playing = false if player.hand_value >= 21
      when '3'
        puts "#{player} has chosen to double."
        new_bet = player.bet * 2
        if new_bet <= player.chips
          double(player, new_bet)
          playing = false
        else
          puts "#{player} doesn\'t have enough chips to double."
          do_turn(player)
        end
      when '4'
        if player.cards.length == 2
          puts "#{player} has chosen to split."
          split
        else
          puts 'It is too late to split.'
          do_turn(player)
        end
      when '5'
        if player.cards.length == 2
          puts "#{player} has chosen to surrender."
          surrender #late surrender
          playing = false
        else
          puts 'It is too late to surrender.'
        end
      else
        puts 'That is an invalid move.'
        do_turn(player)
      end
    end
  end

  def hit(player) #gives card to player, removes card from @cards
    player.cards << @deck.cards.shift
  end

  def double(player, new_bet)
    player.bet = new_bet
    hit(player)
  end

  def split # TODO:
  end

  def surrender(player)
    player.chips = player.chips + (player.bet/2)
    player.cards = []
    player.bet = 0
    player.side_bet = 0 #remove side bet here? ##################################
    player.is_playing = false
  end

  def reveal_card(card)
    puts Deck.interpret(card)
  end



  def won?(player)
    #sc1: p has blackjack, house does not
    #sc2: p has higher than house, not busting
    #sc3: p has lower than house, house busted
    (blackjack?(player) && !blackjack?(@house)) || (player.hand_value > @house.hand_value && !bust?(player)) || bust?(@house) && !bust?(player)
  end

  def quit? #when you walk away or when chips = 0 or when you get kicked out because house is angry100
  end

  def over?
    #blackjack = over
    @players.each do |player|
      if blackjack?(player)
        puts "#{player} has blackjack!"
        return blackjack?(player)
      end
    end
    false
  end

  def blackjack?(player)
    (player.hand_value == 21 && player.cards.length == 2) ? true : false
  end

  def bust?(player) #can't draw more cards
    player.hand_value > 21
  end

  def lost?(player)
    blackjack_getter = @players.select {|player| player if blackjack?(player)}
    (bust?(player) || (blackjack_getter.length > 0 && blackjack_getter.include?(player)) || ((@house.hand_value > player.hand_value) && !bust?(@house))) ? true : false
  end

  def surrender?(player)
    player.is_playing == false
  end

  def draw?(player)
    !bust?(player) && player.hand_value == @house.hand_value
  end

  def distribute_winnings


    @betters.each do |player|
      winnings = 0
      losings = 0
      test_output = ''
      if blackjack?(@house) && blackjack?(player) #double blackjack #####draw + insurance winnings - no change to bets
        test_output = 'double blackjack'
        winnings = (player.side_bet*2) + player.bet#don't double bet - it's a draw
      elsif blackjack?(@house) #house blackjack ########bet value is zero, side_bet stays the same
        test_output = 'house blackjack'
        winnings = (player.side_bet*2)
        losings = player.bet
      elsif draw?(player)
        test_output = 'draw'
        winnings = player.bet #return bet
        losings = player.side_bet

      elsif bust?(player) #player lose
        test_output = 'bust'
        losings = player.side_bet + player.bet

      elsif won?(player) #player win
        test_output = 'player won'
        winnings = (player.bet * 2)
        losings = player.side_bet

      elsif surrender?(player)
        test_output = 'player surrendered'
        winnings = (player.bet/2)
        losings = (player.bet/2)

      elsif lost?(player) #elsif !blackjack?(@house) && !blackjack?(player) && (player_1 player_2 player_3)
        test_output = 'player lost'
        losings = player.side_bet + player.bet
      end

      player.chips = player.chips + winnings
      puts test_output
      puts "#{player} won #{winnings} chips."
      puts "#{player} lost #{losings} chips."
      puts "#{player} has #{player.chips} chips."

      reset_bets(player)

    end
  end

  def reset_bets(player)
    player.bet = 0
    player.side_bet = 0
  end

  def contemplate
    puts ''
    puts 'Would you like to continue (c), change tables (t), or finish this game (f)?'
    cont(@player_1.move)
  end

  def cont(input)
    if input == 'c' || input == 'C'
      do_round
    elsif input == 't' || input == 'T'
      change_table
    elsif input == 'f' || input == 'F'
      puts 'Are you sure you want to leave? All your winnings and losses will reset. Enter "y" for yes and "n" for no.'
      input = gets.chomp
      if input == 'n' || input == 'N'
        contemplate
      elsif input == 'y' || input == 'Y'
      else
        puts 'Your input is invalid. Please try again.'
        cont('f')
      end
    else
      puts 'Your input is invalid. Please try again.'
    end
  end
end
