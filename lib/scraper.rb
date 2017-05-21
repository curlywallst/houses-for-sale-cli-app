require 'open-uri'
require 'pry'

class Scraper


  def self.get_page(index_url)
    @doc = Nokogiri::HTML(open(index_url))
  end

  def self.get_listings(local_page)
    listings = @doc.css("div.js-record-user-activity.js-navigate-to.srp-item div.aspect-content div.srp-item-details")
    scraped_listings=Array.new
    listings.each do |house_node|
      house_hash = {address: " ", price: nil, home_url: " "}
      house_hash[:address] = house_node.css("div.srp-item-address span.listing-street-address").text
      house_hash[:price] = house_node.css("div.srp-item-price span.data-price-display").text
      house_hash[:home_url] = "http://www.realtor.com#{house_node.css("a").attribute('href')}"
      house=House.new(house_hash)
      scraped_listings << house_hash
    end
        binding.pry
    scraped_listings
  end
  # doc = Nokogiri::HTML(open(index_url))
  # student_roster = doc.css("div.student-card")
  # scraped_students=Array.new
  # student_roster.each do |student_node|
  #   @student_hash = {name: " ", location: " ", profile_url: " " }
  #   @student_hash[:name] = student_node.css("h4.student-name").text
  #   if @student_hash[:name] != " "
  #     @student_hash[:location] = student_node.css("p.student-location").text
  #     @student_hash[:profile_url] = student_node.css('a').attribute("href").text
  #     student=Student.new(@student_hash)
  #     scraped_students << @student_hash
  #   end
  # end
  # scraped_students


end
