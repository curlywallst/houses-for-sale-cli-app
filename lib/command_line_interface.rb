require_relative "../lib/scraper.rb"
require_relative "../lib/house.rb"
require 'nokogiri'
require 'colorize'
require 'area'
require 'table_print'


class CommandLineInteface

attr_accessor :zip, :place
BASE_PATH = "http://www.realtor.com/realestateandhomes-search/"

  def initialize
    puts " "
    puts "WELCOME TO HOUSES FOR SALE BY ZIPCODE"
    puts "               -------"
  end

  def run
    zip_input = "y"
    while zip_input == "y" do
      get_zip_code
      House.reset
      get_houses
      display_listings
      details_input = "y"
      while details_input == "y" do
        puts " "
        puts "Would you like further details on any of these fine properties? y/n"
        details_input = gets.strip
        if details_input == "y"
          puts " "
          puts "What is the ID of the property you are interested in?"
          input = gets.strip.to_i
          house_chosen = find_house(input)
          add_attributes_to_houses(house_chosen)
          display_detail(house_chosen)
        end
      end
      puts " "
      puts "Would you like to try another zipcode? y/n"
      zip_input = gets.strip
    end
    puts "It has been a pleasure working with you!  Good luck on your property search!"
  end

  def get_zip_code
    puts " "
    puts "What zipcode would you like to search?:"
    puts " "
    @zip=gets.strip
    @place = @zip.to_region
    location_key=@place.gsub(", ","_")
    @index_url = BASE_PATH+location_key
    puts " "
    puts "Great choice!  #{@place} has many great properties to choose from!"
    puts " "
  end

  def get_houses
    local_page = Scraper.get_page(@index_url)
    listings_array = Scraper.get_listings(local_page)
    House.create_from_collection(listings_array)
  end

  def add_attributes_to_houses(house_chosen)
    attributes = Scraper.scrape_house_listing(house_chosen.home_url)
    house_chosen.add_house_attributes(attributes)
  end

  def find_house(id_selected)
    house_chosen = nil
    House.all.each do |house|
      if house.id == id_selected
        house_chosen = house
      end
    end
    house_chosen
  end


  def display_listings
    puts "---------------------------------------------------------------------------------------------------------"
    puts " "
    puts "  Properties For Sale in #{@place}:"
    puts " "
    tp.set :max_width, 120 # columns won't exceed 120 characters
    tp House.all, :id, :address, :price, :home_url
  end


  def display_detail(house_chosen)
    puts " "
    puts "---------------------------------------------------------------------------------------------------------"
    puts " "
    puts "  Property #{house_chosen.id}: #{house_chosen.address} -- #{house_chosen.price}:"
    puts " "
    puts "#{house_chosen.basic_stats}"
    puts house_chosen.additional_stats
    puts house_chosen.detailed_stats
    puts "House Photograph url: #{house_chosen.photo_url}"
  end

end
