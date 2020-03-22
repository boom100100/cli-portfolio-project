require 'bundler'
Bundler.require

module Players
end

#require 'require_all'
require_relative "../lib/command_line_interface.rb"
require_relative "../lib/deck.rb"
require_relative "../lib/game.rb"
require_relative "../lib/music.rb"
require_relative "../lib/player.rb"
require_relative "../lib/players/computer.rb"
require_relative "../lib/players/human.rb"
require_relative "../lib/players/house.rb"
require_relative "../lib/scraper.rb"
