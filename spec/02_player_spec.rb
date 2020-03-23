require "spec_helper"

describe "Player" do
  let(:player){Player.new}
  describe '#initialize' do
    it "Has a variable called cards" do
      player = Player.new
      expect(defined?(player.cards)).to eq("method")
    end

    it "Has a variable called hand_value" do
      expect(defined?(player.hand_value)).to eq("method")
    end
  end

  describe '#hand_value' do
    it "Calculates player's hand value" do
      player.cards = [
        {card: "S3", value: 3, running_count: 1},
        {card: "C4", value: 4, running_count: 1},
        {card: "HQ", value: 10, running_count: -1}
      ]
      expect(player.hand_value).to eq(17)

      player.cards = [
        {card: "C10", value: 10, running_count: -1},
        {card: "D4", value: 4, running_count: 1},
        {card: "HQ", value: 10, running_count: -1}
      ]
      expect(player.hand_value).to eq(24)
    end
  end
end
