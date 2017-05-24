class House

  attr_accessor :id, :address, :price, :home_url, :photo_url, :acres, :beds, :full_baths, :half_baths, :square_feet
  attr_accessor :bedrooms, :bathrooms, :exterior_and_lot_features, :other_rooms, :building_and_constuction, :accesibility_features
  attr_accessor :waterfront_and_water_access, :garage_and_parking, :heating_and_cooling, :utilities, :amenities_and_community_features
  attr_accessor :homeowners_association, :other_property_info

    @@all = []

    def initialize(attributes_hash) # Initializes with house information - meta
      attributes_hash.each {|key, value| self.send(("#{key}="), value)} # for each listing, initializes it's attributes and values as they exist
      @@all << self
    end

    def self.create_from_collection(listings_array) # Creates an instance of a House for each property in the listings based on the attributes received for that listing
      listings_array.each {|listing| House.new(listing)}
    end

    def add_house_attributes(attributes_hash) # Adds further details to any property of interest
        attributes_hash.each {|key, value| self.send(("#{key}="), value)}
    end

    def self.all
      @@all
    end

    def self.reset
      @@all = []
    end


end
