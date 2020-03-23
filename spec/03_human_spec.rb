describe 'Players::Human' do
  let(:human){Players::Human.new}
  it 'inherits from Player' do
    expect(Players::Human.ancestors).to include(Player)
  end

  it "Has a variable called bet" do
    expect(defined?(human.bet)).to eq("method")
  end

  it "Has a variable called chips" do
    expect(defined?(human.chips)).to eq("method")
  end

  it "Has a variable called net_winnings" do
    expect(defined?(human.net_winnings)).to eq("method")
  end

  it "Has a variable called cards" do
    expect(defined?(human.cards)).to eq("method")
    expect(human.cards).to eq([])
  end
end
