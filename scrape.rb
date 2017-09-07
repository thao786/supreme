#!/usr/bin/ruby

require 'open-uri'
require 'Nokogiri'
require 'json'
require './supre.rb'
require './profiles.rb'

reverse = ARGV[0]
run_again = ARGV[1]

@hots = ["Carry Knife", 
	"Piping Track Jacket", 
	"Blimp", 
	"Half Zip Sweatshirt"]

# @hots = ["Best in the world", "Leather front", "Polo crewneck"]
@all_url = 'http://www.supremenewyork.com/shop/new'
urls = []

def hot? (title)
	@hots.each { |item|
		if title.downcase.include? item.downcase
			return true
		end
	}
	return false
end

def count_all
	doc = Nokogiri::HTML(open(@all_url))
	list = doc.css 'article a'
	list.length
end

p count_all
# count down till page has more items
while count_all == 100 do 
	p 'no update'
	sleep 1
end

all_items_doc = Nokogiri::HTML(open(@all_url))
list = all_items_doc.css 'article a'

if reverse == '1'
	list = list.reverse
end

def scrape (list, profile)
	list.each { |link|
		href = link["href"]
		item_url = "http://www.supremenewyork.com#{href}"
		doc = Nokogiri::HTML(open(item_url))

		# get the title of the item
		div = doc.css '#details h1' # the containing div has id #details
		title = div[0].text

		size_options = doc.css '#s option'
		if size_options.length > 0
			color_p = doc.css '#details p'
			if color_p.length > 1
				color = color_p[0].text.downcase
				if color != 'black'
					break
				end
			end
		end

		# check sold out
		sold_btns = doc.css('.button.sold-out')
		if sold_btns.length == 0
			size_options = doc.css('option')
			if size_options.length > 0
				size = size_options[0].text.downcase

				if size == 'xlarge' 
					break
				end
			end

			if hot?(title) # if the title is in hot list
				urls << item_url
				begin
					buy(item_url, profile) # start scraping
				rescue  
				    p 'scraping failed'
				end  
			end
		end
	}
end

scrape list, @profile1

if run_again == 1
	urls.each { |item_url|
		buy(item_url, @profile2)
	}
end




