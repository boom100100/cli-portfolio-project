class Game
  attr_accessor :deck, :player_1, :player_2, :player_3, :house, :table
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
    choose_table
    do_round
  end

  def do_round
    place_bet
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
    @table = input.to_i
    @deck.make_decks(input.to_i)
    input #doesn't need this return value
  end

  def bet(player, limit, type) #todo write test
    minimum = 5.00
    if type == 'side_bet'
      minimum = 0.00 #if limit < 5
    end

    if player.chips < minimum
      puts 'Would you like to buy more chips? Enter \'y\' or \'n.\''
      input = player.move
      if input == 'y' || input == 'Y'
        player.chips = 500.00
        limit = player.chips
        puts "You now have #{player.chips} chips."
      elsif input == 'n' || input == 'N'
        exit
      end
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
      if limit > 0
        player.send("#{type}=",Random.new.rand(limit-1)+1)
        player.chips = player.chips - player.send("#{type}")

        puts "The computer bets #{player.send("#{type}")}."
      end
    end
  end

  def place_bet
    @betters.each do |player|
      bet(player, player.chips, 'bet')
    end
  end

  def deal
    @players.each do |player|
      puts ''
      while player.cards.length < 2
        hit(player.cards)
      end
      if player != @house
        reveal_cards(player)

      else
        puts "The house's hand has one face-up card:"
        reveal_card(player.cards[0])
        puts ''
      end
    end
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
    if @house.hand_value == 21
      reveal_second
    end

  end

  def play
    @players.each do |player|
      player.hands.each do |hand|
        do_turn(player, hand)
      end
    end
    @betters.each do |player|
      player.hands.each do |hand|
        distribute_winnings(player, hand)
      end
    end
  end

  def do_turn(player, hand)
    if player == @house
      reveal_second
      reveal_cards(player)
    end
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
        hit(hand)
        puts ''
        reveal_cards(player)
        playing = false if player.hand_value >= 21
      when '3'
        puts "#{player} has chosen to double."
        new_bet = player.bet * 2
        if new_bet <= player.chips
          player.chips = player.chips - player.bet
          double(player, hand, new_bet)
          playing = false
        else
          puts "#{player} doesn\'t have enough chips to double."
          do_turn(player, hand)
        end
      when '4'
        if player.cards.length == 2
          puts "#{player} has chosen to split."
          split(player, hand)
        else
          puts 'It is too late to split.'
          do_turn(player, hand)
        end
      when '5'
        if player.cards.length == 2
          puts "#{player} has chosen to surrender."
          surrender(player) #late surrender
          playing = false
        else
          puts 'It is too late to surrender.'
        end
      else
        puts 'That is an invalid move.'
        do_turn(player, hand)
      end
    end
  end

  def hit(hand) #gives card to player, removes card from @cards
    hand << @deck.cards.shift
  end

  def double(player, hand, new_bet) #test result is wrong
    player.bet = new_bet
    hit(hand)
  end

  def split(player, hand) # TODO: looking for .cards where cards needs to be rewritten for multiple hands
    #check cards for duplicate value (card[:value] matches other && card[:card][0..-1] matches other)
    set = Set.new
    i = 0
    duplicate = nil
    hand.each do |card|
      hand.each do |comp_card|
        duplicate = comp_card if ((card != comp_card) && (card[:value] == comp_card[:value]) && (card[:card][1..-1] == comp_card[:card][1..-1]))
      end
    end

    if duplicate

      hand.delete_at(hand.index(duplicate))
      player.hands << [duplicate]
      player.bet << player.bet[0]
      puts player.bet.to_s

    else
      puts 'There are no duplicates.'
      do_turn(player, hand)
    end
  end

  def surrender(player)
    player.is_playing = false
  end

  def reveal_card(card)
    puts Deck.interpret(card)
  end

  def reveal_cards(player)
    puts ''
    puts "This #{player.class} Player has the following cards:"

    player.hands.each do |hand|
      if player.hands.length > 1
        puts 'This hand has:'
      end
      hand.each do |card|
        reveal_card(card)
      end
    end
  end

  def reveal_second
    puts 'The house\'s other card is:'
    reveal_card(@house.cards[1])
  end



  def won?(player, hand)
    #sc1: p has blackjack, house does not
    #sc2: p has higher than house, not busting, no one else has blackjack
    #sc3: p has lower than house, house busted, no one else has blackjack
    blackjack_getter = @players.select {|gambler|
      gambler.hands.each do |hand|
        return gambler if blackjack?(gambler, hand)
      end
    }

    if (player.hand_value(hand) > @house.hand_value(@house.cards) && !bust?(player, hand) && blackjack_getter.length == 0)
      return true
    elsif bust?(@house, @house.cards) && !bust?(player, hand) && blackjack_getter.length == 0
      return true
    else
      false
    end
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

  def blackjack?(player, hand)
    (player.hand_value(hand) == 21 && hand.length == 2) ? true : false
  end

  def bust?(player, hand) #can't draw more cards
    player.hand_value(hand) > 21
  end

  def lost?(player, hand)
    blackjack_getter = @players.select {|player| player if blackjack?(player, hand)}
    (bust?(player, hand) || (blackjack_getter.length > 0 && !blackjack_getter.include?(player)) || ((@house.hand_value(@house.cards) > player.hand_value(hand)) && !bust?(@house, @house.cards))) ? true : false
  end

  def surrender?(player)
    player.is_playing == false
  end

  def draw?(player, hand)
    !bust?(player, hand) && player.hand_value(hand) == @house.hand_value(@house.cards)
  end

  def distribute_winnings(hand, hand_index)
    @betters.each do |player|
      reveal_cards(player)
    end
    @betters.each do |player|
      winnings = 0
      losings = 0

      if blackjack?(@house, @house.cards) && blackjack?(player, hand) #double blackjack #####draw + insurance winnings - no change to bets
        winnings = (player.side_bet*2) + player.bet[hand_index]#don't double bet - it's a draw

      elsif blackjack?(@house) #house blackjack ########bet value is zero, side_bet stays the same
        winnings = (player.side_bet*2)
        losings = player.bet[hand_index]

      elsif blackjack?(player)
        winnings = (player.bet[hand_index]*1.5)
        losings = player.side_bet

      elsif draw?(player)
        winnings = player.bet[hand_index] #return bet
        losings = player.side_bet

      elsif bust?(player, hand) #player lose
        losings = player.side_bet + player.bet[hand_index]

      elsif surrender?(player)
        winnings = (player.bet[hand_index]/2)
        losings = (player.bet[hand_index]/2)
        player.is_playing = true

      elsif lost?(player)
        losings = player.side_bet + player.bet[hand_index]

      elsif won?(player, hand) #player win
        winnings = (player.bet[hand_index] * 2)
        losings = player.side_bet
      end

      player.chips = player.chips + winnings

      puts ''
      puts "#{player} won #{winnings} chips."
      puts "#{player} lost #{losings} chips."
      puts "#{player} has #{player.chips} chips."

      if player == @player_1
        player.net_winnings = player.net_winnings + winnings - losings
        puts "Net winnings is #{player.net_winnings} chips."
        if player.net_winnings > 1000000
          @house.angry = true
        end
      end
      reset(player)

    end
    if @house.angry
      puts 'The House says:'
      puts 'Get out! And take your winnings with you!'
      exit
    end
    @house.hands.each {|hand| hand = []}
  end

  def reset(player)
    player.bet = 0
    player.side_bet = 0

    player.hands = []
    player.cards = []
    player.hands << player.cards
  end

  def contemplate
    puts ''
    puts 'Would you like to continue (c), change tables (t), or finish this game (q)?'
    cont(@player_1.move)
  end

  def cont(input)
    puts ''
    if input == 'c' || input == 'C'
      check_cards
      do_round
    elsif input == 't' || input == 'T'
      change_table
    elsif input == 'q' || input == 'Q'
      puts 'Are you sure you want to quit? All your winnings and losses will reset. Enter "y" for yes and "n" for no.'
      input = gets.chomp
      if input == 'n' || input == 'N'
        contemplate
      elsif input == 'y' || input == 'Y'
        exit
      else
        puts 'Your input is invalid. Please try again.'
        cont('f')
      end
    else
      puts 'Your input is invalid. Please try again.'
      contemplate
    end
  end

  def check_cards
    if @deck.cards.length < (20*@table)
      puts ''
      puts '**********************************'
      puts '**********************************'
      puts '**********************************'
      puts 'It\'s time to reshuffle the cards.'
      puts '**********************************'
      puts '**********************************'
      puts '**********************************'
      puts ''
      @deck.cards = []
      @deck.make_decks(@table)

      @players.each do |player|
        player.hands.each do |hand|

          remove_extras = hand.each do |card|
            i = @deck.cards.index(card)
            @deck.cards.delete_at(i) if i
          end
          remove_extras if hand
        end

      end
    end
  end
end
