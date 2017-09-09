require 'selenium-webdriver'

def buy(url, profile, driver)
  driver.get url

  begin
    submit_btn = driver.find_element(:xpath, "//input[@type='submit' and @value='add to cart']")
  rescue  
      p 'sold out'
      return
  end 
  

  if submit_btn.nil?
    p 'no add to cart button'
    driver.quit
    return
  else
    options = driver.find_elements(:tag_name, "option")
    unless options.nil?
      options.each_with_index do |opt, index| # check size available
          if opt.text.downcase == "small"
            next_size = options[index+1].text
            if next_size.downcase == "medium" # check if next size is medium
              options[index + 1].click
            end

            break
          elsif opt.text.downcase == "xlarge"
            driver.quit
          end
        end
    end

    #proceed to checkout---------------------------
    submit_btn.click

    # driver.execute_script "window.open('_blank', 'payment')"
    # driver.switch_to.window 'payment'
    driver.get "http://supremenewyork.com/checkout"

    # auto-fill---------------------------
    option_country = driver.find_element(:xpath, "//option[@value='CANADA']")
    option_country.click

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
  end

  driver.quit
end

# buy("http://www.supremenewyork.com/shop/tops-sweaters/pdv31bow6/qczlpsyt1")
