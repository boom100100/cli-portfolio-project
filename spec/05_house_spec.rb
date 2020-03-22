describe 'Players::House' do
  let(:house){Players::House.new}
  it 'inherits from Player' do
    expect(Players::House.ancestors).to include(Player)
  end

  it "Has a variable called anger" do
    expect(defined?(house.anger)).to eq("method")
  end


end
