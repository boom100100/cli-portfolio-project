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

  describe '#draw?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.draw?(game.player_1)).to eq(true)

      game.player_1.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.draw?(game.player_1)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      game.house.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      expect(game.draw?(game.player_1)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      game.house.cards = [{card: "S8", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      expect(game.draw?(game.player_1)).to eq(false)
    end
  end

  describe '#won?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.won?(game.player_1)).to eq(false)

      game.player_1.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.won?(game.player_1)).to eq(true)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      game.house.cards = [{card: "S8", value: 8, running_count: 0}, {card: "D10", value: 10, running_count: -1}]
      expect(game.won?(game.player_1)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      game.house.cards = [{card: "S8", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D7", value: 7, running_count: 0}]
      expect(game.won?(game.player_1)).to eq(false)
    end
  end

  describe '#blackjack?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.blackjack?(game.player_1)).to eq(false)

      game.player_1.cards = [{card: "S10", value: 10, running_count: -1}, {card: "DA", value: 11, running_count: -1}]
      expect(game.blackjack?(game.player_1)).to eq(true)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.blackjack?(game.player_1)).to eq(false)

      game.house.cards = [{card: "S7", value: 7, running_count: 0}, {card: "D10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.blackjack?(game.house)).to eq(false)

      game.house.cards = [{card: "S10", value: 10, running_count: -1}, {card: "DA", value: 11, running_count: -1}]
      expect(game.blackjack?(game.house)).to eq(true)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.blackjack?(game.house)).to eq(false)
    end
  end

  describe '#bust?' do
    it "returns appropriate value" do
      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.bust?(game.player_1)).to eq(false)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D10", value: 10, running_count: -1}]
      expect(game.bust?(game.player_1)).to eq(true)

      game.player_1.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.bust?(game.player_1)).to eq(false)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}]
      expect(game.bust?(game.house)).to eq(false)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D10", value: 10, running_count: -1}]
      expect(game.bust?(game.house)).to eq(true)

      game.house.cards = [{card: "H7", value: 7, running_count: 0}, {card: "S10", value: 10, running_count: -1}, {card: "D4", value: 4, running_count: 1}]
      expect(game.bust?(game.house)).to eq(false)
    end
  end

  describe '#distribute_winnings: only house has blackjack' do
    def setup
      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "H2", value: 2, running_count: 1}, {card: "S9", value: 9, running_count: 0}]

      game.player_1.bet = 20
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = game.player_1.side_bet*2
      losings = game.player_1.bet
      [winnings, losings, game.player_1.chips]
    end

    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings }.to output(/has #{(array[0] + array[2])} chips./).to_stdout
    end
  end

  describe '#distribute_winnings: house and current player has blackjack' do # TODO: how to test?
    def setup
      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "SA", value: 11, running_count: -1}, {card: "SJ", value: 10, running_count: -1}]


      game.player_1.bet = 20
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = game.player_1.bet + (game.player_1.side_bet*2)
      losings = 0
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end

  describe '#distribute_winnings: only other player has blackjack' do # TODO: how to test?
    def setup
      game.player_2.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      game.player_1.cards = [{card: "D10", value: 10, running_count: -1}, {card: "SJ", value: 10, running_count: -1}]


      game.player_1.bet = 20
      game.player_1.side_bet = 5
      game.player_1.chips = 50

      winnings = 0
      losings = game.player_1.side_bet + game.player_1.bet
      [winnings, losings, game.player_1.chips]
    end
    it 'calculates winnings' do
      array = setup
      expect { game.distribute_winnings }.to output(/won #{array[0]} chips./).to_stdout

    end
    it 'calculates losings' do
      array = setup
      expect { game.distribute_winnings }.to output(/lost #{array[1]} chips./).to_stdout

    end
    it 'calculates final chips' do
      array = setup
      expect { game.distribute_winnings }.to output(/has #{array[0] + array[2]} chips./).to_stdout
    end

  end
end
