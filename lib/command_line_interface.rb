class CommandLineInterface
  def initialize
  end

  def call
    puts 'Welcome to Blackjack CLI!'
    puts ''
    puts ''
    input = ''
    while input != 'exit'
      puts 'Enter (n) for new game, (t) for tutorial, and (s) for strategy tips.'
      puts ' Enter (m) to set music options.'
      puts 'Enter "exit" to exit.'
      input = gets.chomp
      process_input(input)
    end

  end

  def process_input(input)
    case input
    when "n"
      Game.new.start
      #self.call
    when "t"
      Game.tutorial
    when "s"
      Game.strategy
    when "m"
      if Dir.empty?('./db/mp3s/background_noise')
        Scraper.scrape_pages
      end
      puts ''
      puts 'Do you prefer background noise (b) or casino playlist music (p)?'
      puts 'You can also stop (s) what is playing.'
      input = gets.chomp
      if input.downcase == 'b'
        Music.background_noise_menu
      elsif input.downcase == 'p'
        Music.playlist_menu
      elsif input.downcase == 's'
        Music.stop
        puts ''
      else
        puts ''
        puts 'Input is invalid. Please try again.'
        process_input('m')
        puts ''
      end
    when 'exit'
      Music.stop
    else
      puts ''
      puts 'Input is invalid. Please try again.'
      puts ''
    end
  end
end
