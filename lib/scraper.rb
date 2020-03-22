require 'nokogiri'
require 'open-uri'
require 'pathname'
require 'pry'

class Scraper

  def self.scrape_page(index_url) #https://www.freesfx.co.uk/sfx/casino
    html = open(index_url)
    doc = Nokogiri::HTML(html)
  end

  def self.download_songs()
    
  end

end
