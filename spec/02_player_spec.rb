require "spec_helper"

describe "Player" do
  describe '#initialize' do
    it "Has a variable called cards" do
      player = Player.new
      expect(defined?(player.cards)).to eq("method")
    end
  end
end
