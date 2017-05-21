require_relative "../lib/scraper.rb"
require_relative "../lib/house.rb"
require 'nokogiri'
require 'colorize'
require 'area'


class CommandLineInteface

attr_accessor :town, :state
BASE_PATH = "http://www.realtor.com/realestateandhomes-search/"

  def initialize
    puts "What zipcode would you like to search?:"
    @zip=gets.strip
    @place = @zip.to_region
    location_key=@place.gsub(", ","_")
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
