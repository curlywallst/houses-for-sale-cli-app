class House

    attr_accessor :id, :address, :price, :home_url, :additional_stats, :basic_stats, :detailed_stats, :photo_url, :acres, :bedrooms, :full_baths, :half_baths, :square_feet

      @@all = []

    def initialize(attributes_hash) # Initializes with house information - meta
      attributes_hash.each {|key, value| self.send(("#{key}="), value)}
      @@all << self
    end

    def self.create_from_collection(listings_array)
      listings_array.each {|listing| House.new(listing)}
    end

    def add_house_attributes(attributes_hash)
        attributes_hash.each {|key, value| self.send(("#{key}="), value)}
    end

    def self.all
      @@all
    end

    def self.reset
      @@all = []
    end


end
