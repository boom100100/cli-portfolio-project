describe 'Players::Computer' do
  let(:computer){Players::Computer.new}
  it 'inherits from Player' do
    expect(Players::Computer.ancestors).to include(Player)
  end

  it "Has a variable called bet" do
    expect(defined?(computer.bet)).to eq("method")
  end

  it "Has a variable called chips" do
    expect(defined?(computer.chips)).to eq("method")
  end

end
