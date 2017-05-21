class House

    attr_accessor :address, :price, :home_url

    @@all = []

    def initialize(attributes_hash)
      # binding.pry
      attributes_hash.each {|key, value| self.send(("#{key}="), value)}
      @@all << self
    end

end
