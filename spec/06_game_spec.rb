require "spec_helper"

describe "Game" do
  let(:game){Game.new}
  it "Has a deck" do
    game.deck.make_one_deck
    expect(game.deck.cards).to include({card: "S3", value: 1})
  end

  it "Has players" do
    expect(game.house.is_a? Players::House).to eq(true)
    expect(game.player_1.is_a? Players::Human).to eq(true)
    expect(game.player_2.is_a? Players::Computer).to eq(true)
    expect(game.player_3.is_a? Players::Computer).to eq(true)
  end
end
