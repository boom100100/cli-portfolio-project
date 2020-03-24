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
=begin
  describe '#insurance' do # TODO: how to test?
    it 'does function if first card is Ace' do
      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      #STDOUT.should_receive(:puts).with('Would you like insurance? (y/N)')
      expect(game.insurance).to eq(nil)

      game.house.cards = [{card: "HA", value: 11, running_count: -1}, {card: "S9", value: 9, running_count: -1}]
      expect(game.insurance).to eq(nil)
    end

    it 'doesn\'t do function if first card is not Ace' do
      game.house.cards = [{card: "HK", value: 10, running_count: -1}, {card: "S10", value: 10, running_count: -1}]
      expect(game.insurance).to eq(nil)
    end
  end
=end
end
