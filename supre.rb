require 'selenium-webdriver'

def buy(url, profile, driver)
  driver.get url

  begin
    submit_btn = driver.find_element(:xpath, "//input[@type='submit' and @value='add to cart']")
  rescue  
      p 'sold out'
      return 'fail'
  end 

   # driver.find_element(:xpath, "//option[text()[contains(.,'8.5')]]").click
   driver.find_element(:xpath, "//option[text()[contains(.,'Small')]]").click

  #proceed to checkout---------------------------
  sleep 1
  submit_btn.click

  # driver.execute_script "window.open('_blank', 'payment')"
  # driver.switch_to.window 'payment'
  driver.get "http://supremenewyork.com/checkout"

  # auto-fill---------------------------
  # option_country = driver.find_element(:xpath, "//option[@value='CANADA']")
  # option_country.click

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

  puts 'hit enter when done: '
  gets

  'ok'
end

# buy("http://www.supremenewyork.com/shop/tops-sweaters/pdv31bow6/qczlpsyt1")
