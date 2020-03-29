require 'pathname'
require 'pry'

class Music

  def self.background_noise_menu
    Music.build_menu("background_noise")
  end

  def self.playlist_menu
    Music.build_menu("playlist")
  end

  def self.build_menu(path)
    puts ''
    puts 'Choose from the tracks below.'
    puts 'Enter the number next to the track to play it.'
    puts 'Enter (a) to play all on shuffle.'
    puts ''
    entries = Dir::entries("./db/mp3s/#{path}").drop(2)
    entries.each_with_index do |title, index|
      puts "#{index+1}. #{title}"
    end
    input = gets.chomp
    puts ''
    x = Integer(input) rescue false
    if x && x.between?(1,entries.length)

      fork { exec("mpg123 -q ./db/mp3s/#{path}/#{entries[x-1]}")}
    elsif input == 'a'
      fork { exec("mpg123 -qz ./db/mp3s/#{path}/*")}
    else
      puts 'Input is invalid. Please try again.'
      puts ''
      Music.build_menu(path)
    end
  end

  def self.stop
    fork { exec("killall mpg123")}
  end
end
