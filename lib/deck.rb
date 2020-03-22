class Deck
  attr_reader :cards
  CARDS = [
    {card: "S2", value: 2, running_count: 1}, {card: "S3", value: 3, running_count: 1}, {card: "S4", value: 4, running_count: 1}, {card: "S5", value: 5, running_count: 1}, {card: "S6", value: 6, running_count: 1}, {card: "S7", value: 7, running_count: 0}, {card: "S8", value: 8, running_count: 0}, {card: "S9", value: 9, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "SJ", value: 10, running_count: -1}, {card: "SQ", value: 10, running_count: -1}, {card: "SK", value: 10, running_count: -1}, {card: "SA", value: 10, running_count: -1},
    {card: "C2", value: 2, running_count: 1}, {card: "C3", value: 3, running_count: 1}, {card: "C4", value: 4, running_count: 1}, {card: "C5", value: 5, running_count: 1}, {card: "C6", value: 6, running_count: 1}, {card: "C7", value: 7, running_count: 0}, {card: "C8", value: 8, running_count: 0}, {card: "C9", value: 9, running_count: 0}, {card: "C10", value: 10, running_count: -1}, {card: "CJ", value: 10, running_count: -1}, {card: "CQ", value: 10, running_count: -1}, {card: "CK", value: 10, running_count: -1}, {card: "CA", value: 10, running_count: -1},
    {card: "H2", value: 2, running_count: 1}, {card: "H3", value: 3, running_count: 1}, {card: "H4", value: 4, running_count: 1}, {card: "H5", value: 5, running_count: 1}, {card: "H6", value: 6, running_count: 1}, {card: "H7", value: 7, running_count: 0}, {card: "H8", value: 8, running_count: 0}, {card: "H9", value: 9, running_count: 0}, {card: "H10", value: 10, running_count: -1}, {card: "HJ", value: 10, running_count: -1}, {card: "HQ", value: 10, running_count: -1}, {card: "HK", value: 10, running_count: -1}, {card: "HA", value: 10, running_count: -1},
    {card: "D2", value: 2, running_count: 1}, {card: "D3", value: 3, running_count: 1}, {card: "D4", value: 4, running_count: 1}, {card: "D5", value: 5, running_count: 1}, {card: "D6", value: 6, running_count: 1}, {card: "D7", value: 7, running_count: 0}, {card: "D8", value: 8, running_count: 0}, {card: "D9", value: 9, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "DJ", value: 10, running_count: -1}, {card: "DQ", value: 10, running_count: -1}, {card: "DK", value: 10, running_count: -1}, {card: "DA", value: 10, running_count: -1}
  ]

  def initialize
    @cards = []
  end

  def make_one_deck
    #puts "You have chosen the easy level."
    @cards = CARDS.to_a
  end

  def make_three_decks
    #puts "You have chosen the intermediate level."
    @cards = CARDS.to_a + CARDS.to_a + CARDS.to_a
  end

  def make_six_decks
    #puts "You have chosen the hard level."
    @cards = CARDS.to_a + CARDS.to_a + CARDS.to_a + CARDS.to_a + CARDS.to_a + CARDS.to_a
  end

  def shuffle
    @cards = @cards.shuffle
    #puts "The cards have been shuffled."
  end

  def cut
    half = @cards.length / 2
    @cards = [*@cards[half..-1], *@cards[0..half-1]]
    #puts "The cards have been cut."
  end

  def self.interpret(hash)
    card_name = ''
    card_name = card_name + hash[:card][1..-1].to_s
    case hash[:card][0]
    when 'S'
      card_name = card_name + ' of Spades'
    when 'C'
      card_name = card_name + ' of Clubs'
    when 'H'
      card_name = card_name + ' of Hearts'
    when 'D'
      card_name = card_name + ' of Diamonds'
    end
    card_name
  end

end
