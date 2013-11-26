require 'yaml'
require 'selenium-webdriver'
require 'test/unit'


class RegistrationPage < Test::Unit::TestCase
 #include PageObject
  # To change this template use File | Settings | File Templates.

  #Instantiate browser and read from yaml file

  sign_in_button=""
  log_in_button=""
  site_url=""

  def setUp
    @driver= Selenium::WebDriver.for :firefox
    @properties = YAML.load('properties.yaml')
    @url=@properties['url']['qa']
  end

  def teardown
    @driver.close
  end


  def test_sign_in
   puts @url
   end


  def log_in

  end

end