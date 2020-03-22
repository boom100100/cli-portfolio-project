require "spec_helper"

describe "Deck" do

  let(:deck){Deck.new}

  describe "Deck::Cards" do
    it "Deck enum has 52 cards" do
      expect(Deck::CARDS.length).to eq(52)
    end

    it "Has specific cards" do
      expect(Deck::CARDS).to include({card: "S3", value: 1})
      expect(Deck::CARDS).to include({card: "C4", value: 1})
      expect(Deck::CARDS).to include({card: "HQ", value: -1})
      expect(Deck::CARDS).to include({card: "DJ", value: -1})
      expect(Deck::CARDS).to include({card: "C7", value: 0})
    end
  end
  describe "#make_one_deck" do
    it "Can make a stack of one deck" do
      deck.make_one_deck
      expect(deck.cards).to include({card: "S3", value: 1})
      expect(deck.cards).to include({card: "C4", value: 1})
      expect(deck.cards).to include({card: "HQ", value: -1})
      expect(deck.cards.select{|card| card == {card: "S3", value: 1}}.length).to eq(1)
      expect(deck.cards.select{|card| card == {card: "C4", value: 1}}.length).to eq(1)
      expect(deck.cards.select{|card| card == {card: "HQ", value: -1}}.length).to eq(1)
    end
  end

  describe "#make_three_decks" do
    it "Can make a stack of three decks" do
      deck.make_three_decks
      expect(deck.cards).to include({card: "S3", value: 1})
      expect(deck.cards).to include({card: "C4", value: 1})
      expect(deck.cards).to include({card: "HQ", value: -1})
      expect(deck.cards.select{|card| card == {card: "S3", value: 1}}.length).to eq(3)
      expect(deck.cards.select{|card| card == {card: "C4", value: 1}}.length).to eq(3)
      expect(deck.cards.select{|card| card == {card: "HQ", value: -1}}.length).to eq(3)
    end
  end
  describe "#make_six_decks" do
    it "Can make a stack of six decks" do
      deck.make_six_decks
      expect(deck.cards).to include({card: "S3", value: 1})
      expect(deck.cards).to include({card: "C4", value: 1})
      expect(deck.cards).to include({card: "HQ", value: -1})
      expect(deck.cards.select{|card| card == {card: "S3", value: 1}}.length).to eq(6)
      expect(deck.cards.select{|card| card == {card: "C4", value: 1}}.length).to eq(6)
      expect(deck.cards.select{|card| card == {card: "HQ", value: -1}}.length).to eq(6)
    end
  end
  describe "#shuffle" do
    it "Can shuffle cards" do
      deck.make_one_deck
      save_cards = deck.cards
      deck.shuffle
      expect(deck.cards.length).to eq(52)
      expect(save_cards.length).to eq(52)
      expect(deck.cards == save_cards).to eq(false)
    end
  end

  describe "#cut" do
    it "Can cut cards" do
      deck.make_one_deck
      save_cards = deck.cards
      deck.cut
      expect(deck.cards.length).to eq(52)
      expect(save_cards.length).to eq(52)
      expect(deck.cards == save_cards).to eq(false)
    end
  end

  describe ".interpret" do
    it "Can give full card name" do
      expect(Deck.interpret(Deck::CARDS[0])).to eq("2 of Spades")
      expect(Deck.interpret(Deck::CARDS[9])).to eq("J of Spades")
    end
  end
end
