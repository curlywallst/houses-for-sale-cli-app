require 'open-uri'
require 'pry'

class Scraper


  def self.get_page(index_url) # Gets the page for the appropriate zipcode
    @doc = Nokogiri::HTML(open(index_url))
  end

  def self.get_listings(local_page) # Scrapes the local page for house information - returns an array of hashes = each with listing's attributes
    listings = @doc.css("div.js-record-user-activity.js-navigate-to.srp-item div.aspect-content div.srp-item-details")
    #scraped_listings=Array.new
    index = 1
    listings.each do |house_node| # For each house node found in the listing it scrapes the basic listing information
      house_hash = {id: nil, address: " ", price: nil, home_url: " "}
      house_hash[:id] = index
      index += 1
      house_hash[:address] = house_node.css("div.srp-item-address span.listing-street-address").text
      house_hash[:price] = house_node.css("div.srp-item-price span.data-price-display").text
      house_hash[:home_url] = "./fixtures/greenbriar.html" if house_hash[:address].include?("Greenbriar")
      house_hash[:home_url] = "./fixtures/mitra.html" if house_hash[:address].include?("Mitra")
      house_hash[:home_url] = "./fixtures/colonial.html" if house_hash[:address].include?("Colonial")
      house_hash[:home_url] = "./fixtures/goodwin.html" if house_hash[:address].include?("Goodwin")
      house_hash[:home_url] = "./fixtures/littlebrook.html" if house_hash[:address].include?("Littlebrook")
      house_hash[:home_url] = "./fixtures/old.html" if house_hash[:address].include?("Old")
      house_hash[:home_url] = "./fixtures/crescent.html" if house_hash[:address].include?("Crescent")
      House.new(house_hash)
      #scraped_listings << house_hash # An array of hashes which each contain the house attributes
    end

    #scraped_listings # Returns array hashes - each with listing attributes and values to be used in creation of House instances
  end

  def self.scrape_house_listing(home_url)
    scraped_houses = Hash.new
    doc = Nokogiri::HTML(open(home_url))
    scraped_houses[:photo_url] = doc.css("div.owl-item.active div img").last.attribute("src").value # gets photo url

    lead_details = doc.css("div.listing-subsection.listing-subsection-features div div.load-more-features div.row.js-image-tag div.col-lg-3")
    lead_details.each do |node|
      attribute = nil
      title = node.css("h4")
      attribute = look_for_title_match(title)
      if attribute !=  nil
        details = node.css("ul li")
        info = details.collect {|x| x.text}
        scraped_houses[:"#{attribute}"] = [title.text.strip, info] if info.length != 0
      end
    end

    detail_section = doc.css("div.listing-subsection.listing-subsection-features div div.load-more-features").children
    detail_section.each do |node|
      attribute = nil
      attribute = look_for_title_match(node)
      if attribute !=  nil
        details = node.next.next
        info = details.css("li").collect {|x| x.text}
        scraped_houses[:"#{attribute}"] = [node.text.strip,info] if info.length != 0
      end
    end
    scraped_houses #returns hash of attributes to be added to house instance that user expressed interest in
  end

  private

  def self.look_for_title_match(node)
    attribute =  "bedrooms" if node.text.include?("Bedrooms")
    attribute =  "bathrooms" if node.text.include?("Bathrooms")
    attribute =  "exterior_and_lot_features" if node.text.include?("Exterior and Lot Features")
    attribute =  "other_rooms" if node.text.include?("Other rooms")
    attribute =  "building_and_constuction" if node.text.include?("Building and Construction")
    attribute =  "accesibility_features" if node.text.include?("Accessibility Features")
    attribute =  "waterfront_and_water_access" if node.text.include?("Waterfront and Water Access")
    attribute =  "garage_and_parking" if node.text.include?("Garage and Parking")
    attribute =  "heating_and_cooling" if node.text.include?("Heating and Cooling")
    attribute =  "utilities" if node.text.include?("Utilities")
    attribute =  "amenities_and_community_features" if node.text.include?("Amenities and Community Features")
    attribute =  "homeowners_association" if node.text.include?("Homeowners Association")
    attribute =  "other_property_info" if node.text.include?("Other Property Info")
    attribute
  end

end
