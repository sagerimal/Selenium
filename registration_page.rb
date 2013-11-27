require 'yaml'
require 'selenium-webdriver'
require 'test/unit'



class RegistrationPage < Test::Unit::TestCase


  def setUp
    @driver = Selenium::WebDriver.for :firefox
    @properties = YAML.load_file('properties.yaml')
    @url =
    @username =
    @password= 'qatest11'
    @email_address= "TEST"+Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join +
    @driver.manage.timeouts.implicit_wait = 30
   end

  def teardown
    @driver.quit
  end


  def test_sign_in
    @driver.get(@url)
    @driver.find_element(:xpath, "//span[@id='signin-text']/span").click
    @driver.find_element(:id, "email_form_input").clear
    @driver.find_element(:id, "email_form_input").send_keys(@username)
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys(@password)
    @driver.find_element(:id, "sign-in-button").click

   def log_in

  end




  end
end
