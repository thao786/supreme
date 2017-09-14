#!/usr/bin/ruby

require 'open-uri'
require 'Nokogiri'
require 'json'
require 'selenium-webdriver'
require './supre.rb'
require './profiles.rb'
require './data.rb'

@base_url = 'http://www.supremenewyork.com/shop/all/'
@threads = []
@colors = ['black', 'white', 'red']

def search(title, category)
	found = false
	driver = Selenium::WebDriver.for :chrome

	# sign into Google
	# signinGG driver 

	driver.execute_script "window.open('_blank', 'buy')"
    driver.switch_to.window 'buy'

	while found == false
		begin
			Timeout::timeout(10) {
			driver.get "#{@base_url}#{category}"
		}
		rescue
			next
		end

		links = []
		begin
			links = driver.find_elements(:xpath, "//a[text()[contains(.,'#{title}')]]")
			# check sold out tag and shirt color

			href = links[0].attribute("href")
			p "gonna buy #{title}"
			found = true
			buy(href, @profile1, driver)
		rescue  
		    p "cant find #{title} yet"
		    sleep 1
		end 
	end
end


def signinGG(driver)
	driver.get 'https://gmail.com' 
	driver.find_element(:id => 'identifierId').click
	sleep 1
	driver.action.send_keys(@email).perform
	sleep 1
	driver.action.send_keys(:return).perform
	sleep 1
	driver.action.send_keys(@pass).perform
	sleep 1
	driver.action.send_keys(:return).perform
end

@hots.each { |item|
	t = Thread.new {
		search item[:title], item[:cat]
	}
	@threads << t
}

@threads.each { |t|
	t.join
}

p 'done'
