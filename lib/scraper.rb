require 'nokogiri'
require 'open-uri'
require 'pathname'
require 'pry'
require "fileutils"

class Scraper

  def self.scrape_pages
    #puts 'Scraping.'
    Scraper.scrape(Scraper.get_background_noise)
    Scraper.scrape(Scraper.get_playlist)
    #puts 'Scraping complete.'
  end

private
  def self.get_background_noise
    {url: 'https://retired.sounddogs.com/results.asp?Type=&CategoryID=1016&SubcategoryID=1', domain: 'https://retired.sounddogs.com/', destination: './db/mp3s/background_noise/', splitter: '/', split_index: -1}
  end
  def self.get_playlist
    {url: 'https://freemusicarchive.org/genre/Old-Time__Historic', class: '.playicn', destination: './db/mp3s/playlist/', splitter: '_-_', split_index: -1}
  end

  def self.scrape(hash)

    html = open(hash[:url])
    doc = Nokogiri::HTML(html)
    track_urls = []
    if hash[:class]
      track_url_class = doc.css(hash[:class])
      track_urls = track_url_class.css('a')

    else
      tracks = doc.css('a').select {|tag| tag[:href].match(/mp3/)}

      track_urls << tracks[10]
      track_urls << tracks[17]
      track_urls << tracks[18]

    end

    track_urls.each { |tag|

      if hash[:domain]
        tempfile = URI.parse(hash[:domain]+tag[:href]).open
      else
        tempfile = URI.parse(tag[:href]).open
      end
      tempfile.close
      FileUtils.mv tempfile.path, "#{hash[:destination]}#{tag[:href].split(hash[:splitter])[hash[:split_index]]}"

    }

  end


end
