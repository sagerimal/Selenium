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
    @properties = YAML.load_file('properties.yaml')

  end

    def mteardown
    @driver.close
  end


  def test_sign_in

  puts @properties['url']['qa']
  def log_in

  end

  end
end
