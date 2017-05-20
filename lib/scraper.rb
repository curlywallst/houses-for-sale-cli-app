require 'open-uri'
require 'pry'

class Scraper


  def self.get_page(index_url)
    @doc = Nokogiri::HTML(open(index_url))
  end

  def self.get_listings(local_page)
    listings = @doc.css("div.js-record-user-activity.js-navigate-to.srp-item div.aspect-content div.srp-item-details div.srp-item-address span").text
    # listings = listings.css("div.srp_item-details").text
    binding.pry
  end


end
