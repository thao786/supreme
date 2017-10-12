#!/usr/bin/ruby

require 'open-uri'
require 'Nokogiri'
require 'json'
require 'selenium-webdriver'
require 'uri'
require './supre.rb'
require './profiles.rb'
require './data.rb'

@base_url = 'http://www.supremenewyork.com/shop/all/'
@threads = []
@colors = ['black', 'grey', 'red', 'white']
@time = 1507820400

def search(title, category)
	found = false
	driver = Selenium::WebDriver.for :chrome

	# sign into Google
	# signinGG driver 

	driver.execute_script "window.open('_blank', 'buy')"
    driver.switch_to.window 'buy'

    while Time.now.to_i < @time
    	p 'not time yet. sleep more'
    	sleep 1
    end

	while found == false
		begin
			Timeout::timeout(10) {
			driver.get "#{@base_url}#{category}"
		}
		rescue
			next
		end

		links = []
		links = driver.find_elements(:xpath, "//a[text()[contains(.,'#{title}')]]")
		found = true

		if links.length == 0
			found = false
			p "cant find #{title} yet"
	    	sleep 1
		elsif links.length == 1
			href = links[0].attribute("href")
			p "gonna buy #{title}"
			buy(href, @profile1, driver)
		else # check shirt color
			items = []
			links.each { |link|
				href = link.attribute("href")
				uri = URI.parse(href).request_uri
				item_links = driver.find_elements(:css => "a[href='#{uri}']")
				color = item_links.last.text
				items << {:color => color, :href => href}
			}
			items.sort! { |x,y| score(x) <=> score(y)}
			p items
			items.each { |item|
				if @colors.include? item[:color].downcase
					begin
						p "gonna buy #{title} : #{item[:color]}"
						result = buy(item[:href], @profile1, driver)

						if result == 'ok'
							break
						end
					rescue
					    p "buy #{title} : #{item[:color]} failed"
					    sleep 1
					end
				end
			}
		end
	end
	driver.quit
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

def score(x)
	case x[:color].downcase
      when 'white'
        -100
      when 'grey'
        -90
      when 'red'
    	-70
      when 'black'
        -60
      else
        0
    end
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

