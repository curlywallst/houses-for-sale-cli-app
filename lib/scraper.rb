require 'open-uri'
require 'pry'

class Scraper


  def self.get_page(index_url) # Gets the page for the appropriate zipcode
    @doc = Nokogiri::HTML(open(index_url))
  end

  def self.get_listings(local_page) # Scrapes the local page for house information - returns an array of listings
    listings = @doc.css("div.js-record-user-activity.js-navigate-to.srp-item div.aspect-content div.srp-item-details")
    scraped_listings=Array.new
    index = 1
    listings.each do |house_node|
      house_hash = {id: nil, address: " ", price: nil, home_url: " "}
      house_hash[:id] = index
      index += 1
      house_hash[:address] = house_node.css("div.srp-item-address span.listing-street-address").text
      house_hash[:price] = house_node.css("div.srp-item-price span.data-price-display").text
      house_hash[:home_url] = "www.realtor.com#{house_node.css("a").attribute('href')}"
      scraped_listings << house_hash # An array of hashes which each contain the house attributes
    end
    scraped_listings
  end

  def self.scrape_house_listing(home_url)
    chosen_url = "http://#{home_url}"
    scraped_houses = Hash.new
    doc = Nokogiri::HTML(open(chosen_url))
    scraped_houses[:photo_url] = doc.css("div.owl-item.active div img").last.attribute("src").value

    details = doc.css("div #ldp-detail-keyfacts ul li")
    more_details=[]
    details.each do |i|
      i= i.children.text.gsub("\n", "").strip.split.join(" ")
      more_details << i
    end

    scraped_houses[:additional_stats]= more_details
    details = doc.css("div.sticky-bar-content div.container div ul.property-meta")
    details = details.css("ul li")
    scraped_houses[:half_baths] = "0"
    details.each do |i|
      if i.children.last.text.include?("bed")
        scraped_houses[:bedrooms] = i.css("span").text
      elsif i.children.text.include?("full")
        scraped_houses[:full_baths] = i.css("span").first.text
        if i.children.text.include?("half")
          scraped_houses[:half_baths] = i.css("span").last.text
        end
      elsif i.children.last.text.include?("sq")
        scraped_houses[:square_feet] = i.css("span").text
      elsif i.children.last.text.include?("acre")
        scraped_houses[:acres] = i.css("span").text
      end
    end

    scraped_houses[:lead_sections] = []
    lead_details = doc.css("div.listing-subsection.listing-subsection-features div div.load-more-features div.row.js-image-tag div.col-lg-3")
    lead_details.each do |i|
      section = []
      title = i.css("h4")
      section << title.text
      info = i.css("ul li")
      section_details = []
      info.each do |x|
        section_details << x.text
      end
      section << section_details
      scraped_houses[:lead_sections] << section
    end

    scraped_houses[:sections] = []
    detail_titles = doc.css("div.listing-subsection.listing-subsection-features div div.load-more-features h4.title-subsection-sm")

    detail_titles.each do |i|
      section = []
      section << i.text
      scraped_houses[:sections] << section
    end

    detail_section = doc.css("div.listing-subsection.listing-subsection-features div div.load-more-features div.row")
    index = 0
    title_index = 0
    detail_section.each do |i|
      if index != 0
        section = []
        section_info = i.css("li")
        section_details = []
        section_info.each do |x|
          section_details << x.text
        end
      end

      if index !=0
        scraped_houses[:sections][title_index] << section_details
        title_index += 1
      end
      index += 1
    end

    scraped_houses #returns hash of attributes
  end
end
