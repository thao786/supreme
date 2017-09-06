require 'open-uri'
require 'Nokogiri'
require 'json'

hots = "Contrast Stitch Pullover
Digi Camo"

urls = []

all_url = 'http://www.supremenewyork.com/shop'
all_items_doc = Nokogiri::HTML(open(all_url))
list = all_items_doc.css '.new_item_tag'

list.each { |link|
	# check if this item is hot
	href = link.parent["href"]
	item_url = "http://www.supremenewyork.com#{href}"
	doc = Nokogiri::HTML(open(item_url))

	# get the title of the item
	div = doc.css '#details h1' # the containing div has id #details
	text = div[0].text

	if hots.include? text # if the title is in hot list
		urls << item_url

		# start scraping
		
	end
}

p urls






