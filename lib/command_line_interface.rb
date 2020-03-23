class CommandLineInterface
  def initialize
  end

  def call
    puts 'Welcome to Blackjack CLI!'
    puts ''
    puts ''
    input = ''
    while input != 'exit'
      puts 'Enter "n" for new game, "t" for tutorial, and "s" for strategy tips.'
      puts ' Enter "m" to set music options.'
      puts 'Enter "exit" to exit at any time.'
      input = gets.chomp
      process_input(input)
    end

  end

  def process_input(input)
    case input
    when "n"
      Game.new.start
    when "t"
      Game.tutorial
    when "s"
      Game.strategy
    when "m"
      puts "Code music functionality"
    end
  end
end
