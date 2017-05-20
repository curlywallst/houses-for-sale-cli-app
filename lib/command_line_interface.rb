require_relative "../lib/scraper.rb"
require_relative "../lib/house.rb"
require 'nokogiri'
require 'colorize'



class CommandLineInteface

attr_accessor :town, :state
BASE_PATH = "http://www.realtor.com/realestateandhomes-search/"

  def initialize
    puts "your town?:"
    town=gets.strip
    puts "your state?:"
    state = gets.strip
    location_key = "#{town}_#{state}"
    @index_url = BASE_PATH+location_key
  end

  def run
    self.get_houses

    display_listings
  end

  def get_houses
    local_page = Scraper.get_page(@index_url)
    listings = Scraper.get_listings(local_page)
  end

  def display_listings

  end



end
