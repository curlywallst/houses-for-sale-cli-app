require 'open-uri'
require 'pry'

class Scraper


  def self.get_page(index_url) # Gets the page for the appropriate zipcode
    @doc = Nokogiri::HTML(open(index_url))
  end

  def self.get_listings(local_page) # Scrapes the local page for house information - returns an array of listings
    listings = @doc.css("div.js-record-user-activity.js-navigate-to.srp-item div.aspect-content div.srp-item-details")
    scraped_listings=Array.new
    listings.each do |house_node|
      house_hash = {address: " ", price: nil, home_url: " "}
      house_hash[:address] = house_node.css("div.srp-item-address span.listing-street-address").text
      house_hash[:price] = house_node.css("div.srp-item-price span.data-price-display").text
      house_hash[:home_url] = "http://www.realtor.com#{house_node.css("a").attribute('href')}"
      scraped_listings << house_hash # An array of hashes which each contain the house attributes
    end
    binding.pry
    scraped_listings
  end

  def self.scrape_house_listing(home_url)
    scraped_houses = Hash.new
    doc = Nokogiri::HTML(open(home_url))

    scraped_houses[:photo_url] = doc.css("div.owl-item.active div img").last.attribute("src").value

    details = doc.css("div #ldp-detail-keyfacts ul li")
    more_details=[]
    details.each do |i|
      i= i.children.text.gsub("\n", "").strip.split.join(" ")
      more_details << i
    end
    scraped_houses[:additional_stats]= more_details

    details = doc.css("div.sticky-bar-content div.container div ul.property-meta")
    more_details = details.children.text.gsub("\n", "").strip.split.join(" ")
    scraped_houses[:basic_stats] = more_details

    details = doc.css("div.listing-subsection.listing-subsection-features div div.load-more-features div.row div.col-sm-6 ul li")
    more_details = []
    details.each do |i|
      more_details << i.text
    end
    scraped_houses[:detailed_stats] = more_details
    scraped_houses #returns hash of attributes
  end


end
