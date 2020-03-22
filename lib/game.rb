class Game
  attr_accessor :deck, :player_1, :player_2, :player_3, :house
  #play 1. all players place a bet. 2. one face up card clockwise, including one to dealer. 3. one more face up to each, except to dealer. Dealer's is face down. 4. If non-dealer has natural, player receives 1.5 of bet. If only dealer has natural, all other players lose bet. If there is a natural tie between dealer and player,
  def initialize(deck = nil, house = nil, p1 = nil, p2 = nil, p3 = nil)
    @deck = Deck.new unless @deck = deck

    @house = Players::House.new unless @house = house
    @player_1 = Players::Human.new unless @player_1 = p1
    @player_2 = Players::Computer.new
    @player_3 = Players::Computer.new
  end

  def place_bet(player)
    wager = gets
    if wager <= player.chips
      bet = wager
    else
      puts "You don't have enough chips for that wager."
      place_bet
    end

  end
  def hit(player) #gives card to player, removes card from @cards
  end

  def reveal(player) #shows player's cards
  end
end
