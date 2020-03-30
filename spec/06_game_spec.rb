require "spec_helper"

describe "Game" do
  let(:game){Game.new}

  it "Has a deck" do
    game.deck.make_decks(1)
    expect(game.deck.cards).to include({card: "S3", value: 3, running_count: 1})
  end

  it "Has players" do
    expect(game.house.is_a? Players::House).to eq(true)
    expect(game.player_1.is_a? Players::Human).to eq(true)
    expect(game.player_2.is_a? Players::Computer).to eq(true)
    expect(game.player_3.is_a? Players::Computer).to eq(true)
  end

  describe '#choose_table' do
    it 'makes stack of 1 deck when table 1 chosen' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('1')
      expect(game.choose_table(@table)).to eq('1')
      expect(game.deck.cards.length).to eq(52)
    end
    it 'makes stack of 3 decks when table 3 chosen' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('3')
      expect(game.choose_table(@table)).to eq('3')
      expect(game.deck.cards.length).to eq(52*3)
    end
    it 'makes stack of 8 decks when table 8 chosen' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('8')
      expect(game.choose_table(@table)).to eq('8')
      expect(game.deck.cards.length).to eq(52*8)
      expect(game.deck.cards.select{|card| card[:card] == 'S2'}.length).to eq(8)
    end
    it 'allows duplicate cards when there are multiple decks' do
      decks = Random.new.rand(1..8)
      allow_any_instance_of(Kernel).to receive(:gets).and_return(decks.to_s)
      expect(game.choose_table(@table)).to eq(decks.to_s)
      expect(game.deck.cards.select{|card| card[:card] == 'S2'}.length).to eq(decks)
    end
  end

  describe '#bet' do
    it 'recognizes valid output' do
      game.player_1.chips = 500
      bet = Random.new.rand(game.player_1.chips-10)+1 #+1 to prevent return of 0

      #input is wager
      allow_any_instance_of(Kernel).to receive(:gets).and_return(bet.to_s)

      expect { game.bet(game.player_1, game.player_1.chips, 'bet') }.to output(/Your bet is/).to_stdout

    end
    it 'doesn\'t allow a bet that\'s too high' do
      game.player_1.chips = 500
      bet = 501

      allow_any_instance_of(Kernel).to receive(:gets).and_return(bet.to_s)

      expect(game.player_1.bet).to eq([0])

    end

    it 'doesn\'t allow a bet that\'s too low' do
      game.player_1.chips = 500
      bet = 1

      allow_any_instance_of(Kernel).to receive(:gets).and_return(bet.to_s)

      expect(game.player_1.bet).to eq([0])
    end
  end

  describe '#double' do
    it "doubles the player's bet" do
      game.player_1.hands = []
      game.player_1.cards = [{card: "H3", value: 3, running_count: 1}, {card: "D6", value: 6, running_count: 1}]
      game.player_1.hands << game.player_1.cards

      game.player_1.bet = [50]
      new_bet = (game.player_1.bet[0][0] * 2)
      game.deck.make_decks(1)

      game.double(game.player_1, game.player_1.cards, 0, new_bet)
      expect(game.player_1.bet[0]).to eq(100)
    end
  end

  describe '#draw?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.draw?(game.player_1, game.player_1.cards)).to eq(true)

      game.player_1.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.draw?(game.player_1, game.player_1.cards)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      game.house.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      expect(game.draw?(game.player_1, game.player_1.cards)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      game.house.cards = [{card: "S8", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      expect(game.draw?(game.player_1, game.player_1.cards)).to eq(false)
    end
  end

  describe '#won?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.won?(game.player_1, game.player_1.cards)).to eq(false)

      game.player_1.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.won?(game.player_1, game.player_1.cards)).to eq(true)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      game.house.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      expect(game.won?(game.player_1, game.player_1.cards)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      game.house.cards = [{card: "S8", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      expect(game.won?(game.player_1, game.player_1.cards)).to eq(false)
    end
  end

  describe '#blackjack?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.blackjack?(game.player_1, game.player_1.cards)).to eq(false)

      game.player_1.cards = [{card: "S10", value: 10, running_count: -1}, {card: "DA", value: 11, running_count: -1}]
      expect(game.blackjack?(game.player_1, game.player_1.cards)).to eq(true)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.blackjack?(game.player_1, game.player_1.cards)).to eq(false)

      game.house.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.blackjack?(game.house, game.house.cards)).to eq(false)

      game.house.cards = [{card: "S10", value: 10, running_count: -1}, {card: "DA", value: 11, running_count: -1}]
      expect(game.blackjack?(game.house, game.house.cards)).to eq(true)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.blackjack?(game.house, game.house.cards)).to eq(false)
    end
  end

  describe '#bust?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.bust?(game.player_1, game.player_1.cards)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D10", value: 10, running_count: -1}]
      expect(game.bust?(game.player_1, game.player_1.cards)).to eq(true)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.bust?(game.player_1, game.player_1.cards)).to eq(false)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.bust?(game.house, game.house.cards)).to eq(false)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D10", value: 10, running_count: -1}]
      expect(game.bust?(game.house, game.house.cards)).to eq(true)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.bust?(game.house, game.house.cards)).to eq(false)
    end
  end

  describe '#distribute_winnings: only house has blackjack' do
    def setup
      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "H2", value: 2, running_count: 1}, {card: "S9", value: 9, running_count: 0}]

      game.player_1.send('bet=', 20, 0)
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = game.player_1.side_bet*2
      losings = game.player_1.bet[0]
      [winnings, losings, game.player_1.chips]
    end

    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{(array[0] + array[2])} chips./).to_stdout
    end
  end

  describe '#distribute_winnings: house and human player have blackjack' do
    def setup
      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "SA", value: 11, running_count: -1}, {card: "SJ", value: 10, running_count: -1}]


      game.player_1.send('bet=', 20, 0)
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = game.player_1.bet[0] + (game.player_1.side_bet*2)
      losings = 0
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end

  describe '#distribute_winnings: only human player has blackjack' do
    def setup
      #game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "SA", value: 11, running_count: -1}, {card: "SJ", value: 10, running_count: -1}]


      game.player_1.send('bet=', 20, 0)
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = game.player_1.bet[0]*1.5
      losings = game.player_1.side_bet
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end

  describe '#distribute_winnings: only computer player has blackjack' do
    def setup

      game.player_1.hands = []
      game.player_2.hands = []
      game.house.hands = []

      game.player_2.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "D10", value: 10, running_count: -1}, {card: "SJ", value: 10, running_count: -1}]
      split_cards = [{card: "H10", value: 10, running_count: -1}, {card: "C4", value: 4, running_count: 1}]
      game.house.cards = [{card: "D9", value: 9, running_count: 0}, {card: "S8", value: 8, running_count: 0}]

      game.player_1.hands << game.player_1.cards
      game.player_1.hands << split_cards

      game.player_2.hands << game.player_2.cards
      game.house.hands << game.house.cards

      game.player_1.send('bet=', 20, 0)
      game.player_1.send('bet=', 20, 1)
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings1 = 0
      losings1 = game.player_1.side_bet + game.player_1.bet[0]

      winnings3 = 0
      losings3 = game.player_1.bet[1]

      game.player_1.send('bet=', 20, 0)
      game.player_2.side_bet = 5
      game.player_2.chips = 50

      winnings2 = game.player_2.bet[0]*1.5
      losings2 = game.player_2.side_bet

      [winnings1, losings1, game.player_1.chips, winnings2, losings2, game.player_2.chips, winnings3, losings3, game.player_1.chips]
    end

    it 'calculates human player\'s winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout
    end

    it 'calculates human player\'s losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout
    end

    it 'calculates human player\'s final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

    it 'calculates computer player\'s winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_2, game.player_2.cards, 0) }.to output(/won #{array[3]} chips./).to_stdout

    end
    it 'calculates computer player\'s losings' do
      array = setup
      expect { game.distribute_winnings(game.player_2, game.player_2.cards, 0) }.to output(/lost #{array[4]} chips./).to_stdout

    end
    it 'calculates computer player\'s final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_2, game.player_2.cards, 0) }.to output(/has #{array[3] + array[5]} chips./).to_stdout
    end

    it 'calculates human player\'s winnings when hand is split' do
      array = setup

      expect { game.distribute_winnings(game.player_1, game.player_1.hands[1], 1) }.to output(/won #{array[6]} chips./).to_stdout
    end

    it 'calculates human player\'s losings when hand is split' do
      array = setup

      expect { game.distribute }.to output(/lost #{array[7]} chips./).to_stdout
    end

    it 'calculates human player\'s final chips when hand is split' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.hands[1], 1) }.to output(/has #{array[0] + array[6] + array[8]} chips./).to_stdout
    end

  end

  describe '#distribute_winnings: draw' do
    def setup
      #game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "S10", value: 10, running_count: -1}, {card: "SJ", value: 10, running_count: -1}]
      game.house.cards = [{card: "H2", value: 2, running_count: 1}, {card: "D9", value: 9, running_count: 0}, {card: "S9", value: 9, running_count: 0}]


      game.player_1.send('bet=', 20, 0)
      game.player_1.side_bet = 0
      game.player_1.chips = 50

      winnings = game.player_1.bet[0]
      losings = game.player_1.side_bet
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end

  describe '#distribute_winnings: won' do
    def setup

      game.player_1.cards = [{card: "S10", value: 10, running_count: -1}, {card: "H9", value: 9, running_count: 0}]
      game.player_2.cards = [{card: "H10", value: 10, running_count: -1}, {card: "D9", value: 9, running_count: 0}]
      game.player_3.cards = [{card: "HA", value: 11, running_count: -1}, {card: "C9", value: 9, running_count: 0}]
      game.house.cards = [{card: "SA", value: 11, running_count: -1}, {card: "D5", value: 5, running_count: 1}, {card: "S2", value: 2, running_count: 1}]


      game.player_1.send('bet=', 20, 0)
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = game.player_1.bet[0]*2
      losings = game.player_1.side_bet
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end

  describe '#distribute_winnings: lost' do
    def setup

      game.player_3.cards = [{card: "S10", value: 10, running_count: -1}, {card: "H9", value: 9, running_count: 0}]
      game.player_2.cards = [{card: "H10", value: 10, running_count: -1}, {card: "D9", value: 9, running_count: 0}]
      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "C9", value: 9, running_count: 0}]
      game.player_1.cards = [{card: "SA", value: 11, running_count: -1}, {card: "D5", value: 5, running_count: 1}, {card: "S2", value: 2, running_count: 1}]


      game.player_1.send('bet=', 20, 0)
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = 0
      losings = game.player_1.bet[0] + game.player_1.side_bet
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings(game.player_1, game.player_1.cards, 0) }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end

  describe '#check_cards' do
    it 'removes cards from deck if present in player\'s hand' do
      game.player_1.hands = []
      game.player_2.hands = []

      game.player_1.cards = [{card: "S2", value: 2, running_count: 1}, {card: "S3", value: 3, running_count: 1}, {card: "S4", value: 4, running_count: 1}]
      game.player_2.cards = [{card: "S5", value: 5, running_count: 1}, {card: "S6", value: 6, running_count: 1}, {card: "S7", value: 7, running_count: 0}]

      game.player_1.hands << game.player_1.cards
      game.player_2.hands << game.player_2.cards

      game.table = 1
      game.check_cards
      expect(game.deck.cards.length).to eq(46)
    end

    it 'doesn\'t delete duplicate cards if not appropriate' do

      game.player_1.hands = []

      game.player_1.cards = [{card: "S2", value: 2, running_count: 1}, {card: "S3", value: 3, running_count: 1}, {card: "S4", value: 4, running_count: 1}]

      game.player_1.hands << game.player_1.cards

      game.table = 2
      game.check_cards
      expect(game.deck.cards.length).to eq(101)
    end

    it 'deletes duplicate cards if appropriate' do
      game.player_1.hands = []

      game.player_1.cards = [{card: "S2", value: 2, running_count: 1}, {card: "S2", value: 2, running_count: 1}, {card: "S3", value: 3, running_count: 1}, {card: "S4", value: 4, running_count: 1}]

      game.player_1.hands << game.player_1.cards

      game.table = 2
      game.check_cards
      expect(game.deck.cards.length).to eq(100)
    end
  end

  describe '#split' do
    it 'finds duplicate value if present' do


      game.player_1.hands = []
      game.player_1.cards = [{card: "CA", value: 11, running_count: -1}, {card: "SA", value: 11, running_count: -1}]

      game.player_1.hands << game.player_1.cards

      game.deck.make_decks(1)

      game.split(game.player_1, game.player_1.cards, 0)

      expect(game.player_1.hands[0]).to include({card: "SA", value: 11, running_count: -1})
      expect(game.player_1.hands[1]).to include({card: "CA", value: 11, running_count: -1})
    end

    it 'doesn\'t find duplicate value if there is none' do
      game.player_1.hands = []
      game.player_1.cards = [{card: "CA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]

      game.player_1.hands << game.player_1.cards

      game.deck.make_decks(1)

      game.split(game.player_1, game.player_1.cards, 0)

      expect(game.player_1.hands).to eq([[{card: "CA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]])
    end

    it 'creates two hands' do
      game.player_1.hands = []
      game.player_1.cards = [{card: "CA", value: 11, running_count: -1}, {card: "SA", value: 11, running_count: -1}]

      game.player_1.hands << game.player_1.cards
      game.deck.make_decks(1)

      game.split(game.player_1, game.player_1.cards, 0)

      expect(game.player_1.hands.length).to eq(2)
    end

    it 'can split if hand already has more than 2 cards' do
      game.player_1.hands = []
      game.player_1.cards = [{card: "CA", value: 11, running_count: -1}, {card: "SA", value: 11, running_count: -1}, {card: "H2", value: 2, running_count: 1}]

      game.player_1.hands << game.player_1.cards

      game.deck.make_decks(1)

      game.split(game.player_1, game.player_1.cards, 0)

      expect(game.player_1.hands.length).to eq(2)
      expect(game.player_1.hands[0].length).to eq(2)
      expect(game.player_1.hands[1].length).to eq(2)

      expect(game.player_1.hands[0]).to eq([{:card=>"SA", :value=>11, :running_count=>-1}, {:card=>"H2", :value=>2, :running_count=>1}])
      expect(game.player_1.hands[1]).to include({:card=>"CA", :value=>11, :running_count=>-1})
    end

    it 'can split if player already has multiple hands' do
      game.player_1.hands = []
      game.player_1.cards = [{card: "CA", value: 11, running_count: -1}, {card: "SA", value: 11, running_count: -1}, {card: "H2", value: 2, running_count: 1}]
      second_hand = [{card: "S2", value: 2, running_count: 1}]
      game.player_1.hands << game.player_1.cards
      game.player_1.hands << second_hand

      game.deck.make_decks(1)
      game.split(game.player_1, game.player_1.cards, 0)

      expect(game.player_1.hands.length).to eq(3)

      expect(game.player_1.hands[0]).to eq([{:card=>"SA", :value=>11, :running_count=>-1}, {:card=>"H2", :value=>2, :running_count=>1}])
      expect(game.player_1.hands[1]).to include({:card=>"S2", :value=>2, :running_count=>1})
      expect(game.player_1.hands[2]).to include({:card=>"CA", :value=>11, :running_count=>-1})
    end
  end
end
