require 'selenium-webdriver'

def buy(url, profile, driver)
  driver.get url

  begin
    options = driver.find_elements(:tag_name, "option")
    # submit_btn = driver.find_element(:xpath, "//input[@type='submit' and @value='add to cart']")
  rescue  
      return 'fail cuz sold out'
  end 

  unless options.nil?
    options.each_with_index do |opt, index| # check size available
        if opt.text.downcase == "small"
          options[index + 2].click
          break
        elsif opt.text.downcase == "medium"
          options[index + 1].click
          break
        elsif opt.text.downcase == "large"
          break
        elsif opt.text.downcase == "xlarge"
          break
        end
    end
  end
puts 'at line 28 '

  #proceed to checkout---------------------------
  # sleep 1
  # submit_btn.click
  driver.execute_script("document.getElementById('add-remove-buttons').firstChild.click();")
  driver.get "http://supremenewyork.com/checkout"

  # auto-fill---------------------------
  input_form = driver.execute_script("
            var credit_info = ['#{profile[:name]}', 
                  '#{profile[:email]}', 
                  '#{profile[:phone]}', 
                  '#{profile[:address]}', 
                  '', 
                  '#{profile[:zipcode]}', 
                  '#{profile[:city]}', 
                  '#{profile[:card]}', 
                  '#{profile[:security]}'];             
            var card_info = ['#{profile[:state]}',
                  '#{profile[:expire_month]}',
                  '#{profile[:expire_year]}'];
            
            var inputs_prototype = document.getElementsByTagName('input');
            var inputs = [];
            for (var i=0; i < inputs_prototype.length; i++){
                if (inputs_prototype[i].type == 'text' || inputs_prototype[i].type == 'email'){
                  inputs.push(inputs_prototype[i]);
                }
            }
            for (var i=0; i < inputs.length; i++){
                  inputs[i].value = credit_info[i];
            }
            $('.icheckbox_minimal')[1].click();
            var selects = document.getElementsByTagName('select');
            selects[0].value = card_info[0];
            selects[2].value = card_info[1];
            selects[3].value = card_info[2];")

  process_btn = driver.find_element(:xpath, "//input[@type='submit' and @value='process payment']") #fix this xpath for input
  process_btn.click

  # sleep 1
  # use_credit_btn = driver.find_element(:xpath, "//input[@type='submit' and @value='Use Store Credit']")
  # use_credit_btn.click
  # sleep 1

  puts 'hit enter when done: '
  gets

  'ok'
end

