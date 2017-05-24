require 'nokogiri'
require 'colorize'
require 'area'
require 'table_print'


class CommandLineInteface

attr_accessor :zip, :place
BASE_PATH = "./fixtures/"

  def initialize #Wecomes user
    puts " "
    puts "WELCOME TO HOUSES FOR SALE BY ZIPCODE".green
    puts "               -------"
  end

  def run
    zip_input = "y"
    while zip_input == "y" do
      get_zip_code  # Takes zipcode from user, Turns it into City, St, and gets url for listings page
      House.reset  # Clears houses
      get_houses  # Gets houses from listing page
      display_listings  # Displays listings
      details_input = "y"
      while details_input == "y" do
        puts " "
        puts "Would you like further details on any of these fine properties? y/n".green # Asks user if they want more info on any house
        details_input = gets.strip
        if details_input == "y" # Gets more info if the user wants it
          puts " "
          puts "What is the ID of the property you are interested in?".green
          input = gets.strip.to_i
          house_chosen = find_house(input)
          add_attributes_to_houses(house_chosen) # Adds the further details to the house instance
          display_detail(house_chosen)  # Displays the detailed listing information
        end
      end
      puts " "
      puts "Would you like to try another zipcode? y/n".green # Asks user if they want to try another zipcode
      zip_input = gets.strip
    end
    puts "It has been a pleasure working with you!  Good luck on your property search!".green # If not, says goodbye to user
  end

  def get_zip_code
    puts " "
    puts "What zipcode would you like to search?:".green
    puts " "
    @zip=gets.strip
    @place = @zip.to_region # Uses area gem to get location
    location_key=@place.gsub(", ","_")
    location_pointer = "eliot.html" if @zip == "03903"
    location_pointer = "portsmouth.html" if @zip == "03801"
    @index_url = BASE_PATH+location_pointer # Creates url of listing page for location
    puts " "
    puts "Great choice!  #{@place} has many great properties to choose from!".green
    puts " "
  end

  def get_houses
    local_page = Scraper.get_page(@index_url) # Gets listing page for the location
    listings_array = Scraper.get_listings(local_page) # Gets array of hashes - each hash is attributes and values for a listing
    House.create_from_collection(listings_array) # Creates houses from listing array
  end

  def add_attributes_to_houses(house_chosen) # If user wants more info gets more listing details and adds them to the chosen house
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
    puts "  Properties For Sale in #{@place}:".red
    puts " "
    tp.set :max_width, 120 # columns won't exceed 120 characters
    tp House.all, :id, :address, :price
  end


  def display_detail(house_chosen)
    puts " "
    puts "---------------------------------------------------------------------------------------------------------"
    puts " "
    puts "  Property #{house_chosen.id}: #{house_chosen.address} -- #{house_chosen.price}:".red
    puts "  -----------------------------------------------------"
    puts " "
    print_section(house_chosen.bedrooms)
    print_section(house_chosen.bathrooms)
    print_section(house_chosen.exterior_and_lot_features) if house_chosen.exterior_and_lot_features
    print_section(house_chosen.other_rooms) if house_chosen.other_rooms
    print_section(house_chosen.building_and_constuction) if house_chosen.building_and_constuction
    print_section(house_chosen.accesibility_features) if house_chosen.accesibility_features
    print_section(house_chosen.waterfront_and_water_access) if house_chosen.waterfront_and_water_access
    print_section(house_chosen.garage_and_parking) if house_chosen.garage_and_parking
    print_section(house_chosen.heating_and_cooling) if house_chosen.heating_and_cooling
    print_section(house_chosen.utilities) if house_chosen.utilities
    print_section(house_chosen.amenities_and_community_features) if house_chosen.amenities_and_community_features
    print_section(house_chosen.homeowners_association) if house_chosen.homeowners_association
    print_section(house_chosen.other_property_info) if house_chosen.other_property_info
    puts " "
    puts "House Photograph url: #{house_chosen.photo_url}".red
  end

  def print_section(section)
    puts section[0].blue
    puts "----------------------------------------"
    section[1].each do |i|
      puts i
    end
    puts " "
  end

end
