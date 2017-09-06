require 'open-uri'
require 'Nokogiri'
require 'json'
require './supre.rb'

hots = ["Carry Knife", 
	"Piping Track Jacket", 
	"Blimp", 
	"Half Zip Sweatshirt"]

def hot? (title)
	hots.each { |item|
		if title.include? item
			p title
			return true
		end
	}
	return false
end


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
	title = div[0].text

	color_p = doc.css '#details p'
	color = color_p[0].text.downcase

	size = doc.css('option')[0].text.downcase

	if color == 'black' && size != 'xlarge'
		if hot?(title) # if the title is in hot list
			p item_url
			buy(item_url) # start scraping
		end
	end
}







