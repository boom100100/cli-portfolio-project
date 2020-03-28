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
      puts 'Enter "exit" to exit.'
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
      Scraper.scrape_pages
      puts ''
      puts 'Do you prefer background noise (b) or casino playlist music (p)?'
      input = gets.chomp
      if input.downcase == 'b'
      elsif input.downcase == 'p'
      else
        puts ''
        puts 'Input is invalid. Please try again.'
        process_input('m')
        puts ''
      end
    when 'exit'
    else
      puts ''
      puts 'Input is invalid. Please try again.'
      puts ''
    end
  end
end
