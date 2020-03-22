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
end
