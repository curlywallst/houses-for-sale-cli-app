require_relative "../lib/scraper.rb"
require_relative "../lib/house.rb"
require 'nokogiri'
require 'colorize'
require 'area'


class CommandLineInteface

attr_accessor :zip, :place
BASE_PATH = "http://www.realtor.com/realestateandhomes-search/"

  def initialize
    puts "What zipcode would you like to search?:"
    @zip=gets.strip
    @place = @zip.to_region
    location_key=@place.gsub(", ","_")
    @index_url = BASE_PATH+location_key
  end

  def run
    get_houses
    add_attributes_to_houses
    display_listings
  end

  def add_attributes_to_houses
    House.all.each do |house|
      attributes = Scraper.scrape_house_listing(house.home_url)
      binding.pry
      house.add_house_attributes(attributes)
          binding.pry
    end

  end

  def get_houses
    local_page = Scraper.get_page(@index_url)
    listings_array = Scraper.get_listings(local_page)
    House.create_from_collection(listings_array)
  end

  def display_listings

  end



end
