require "selenium-webdriver"
require "test/unit"
require "YAML"

class SmokeTest < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    new_file=YAML.load_file("properties.yaml")
    @url= new_file["url"]["qa"]
    @username = new_file["signin"]["username"]
    @password=  new_file["signin"]["password"]
    @email_address= "TEST"+Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join + "@" +new_file["registration"]["email_domain"]
    @search_zipcode='90405'
    @search_city="Santa Monica"
    @page_title=new_file["site"]["page_title"]

  end


  def  teardown
    @driver.quit
  end


  def login
    @driver.get(@url)
    @driver.find_element(:xpath, "//span[@id='signin-text']/span").click
    @driver.find_element(:id, "email_form_input").clear
    @driver.find_element(:id, "email_form_input").send_keys(@username)
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys(@password)
    @driver.find_element(:id, "sign-in-button").click
  end


  def mtest_alt_registration
    @driver.get(@url + "/")
    @driver.find_element(:id, "freeform_submarket_nm").clear
    @driver.find_element(:id, "freeform_submarket_nm").send_keys "90278"
    @driver.find_element(:css, "button.btn.cancel").click
    sleep(2)
    properties=@driver.find_elements(:css, "img")
    properties[0].click
    #@driver.find_element(:link, "Next").click
    sleep 2
    @driver.find_element(:css, "#carousel-reg-form input").send_keys(@email_address)
    @driver.find_element(:xpath, "//input[@value='Create a Free Account']").click
    @driver.find_element(:id, "password").click
    sleep 4
    @driver.find_element(:id, "password").send_keys "sage"
    @driver.find_element(:link, "Submit").click
    assert_include( @driver.title,'Hermosa Beach',)

  end


  def mtest_home_page
    @driver.navigate.to(@url)
    puts @driver.title
    assert_include( @driver.title,@page_title)
  end


  def mtest_property_search
    login()
    @driver.get(@url+'/search/results/')
    @driver.find_element(:id, "search-near").clear
    @driver.find_element(:id, "search-near").send_keys "santa monica, ca"
    @driver.find_element(:css, "button.btn.btn-search").click
    @address=@driver.find_elements(:css,".prop-address")
    assert_include( @address[0].text,'Santa Monica',)
  end




  def mtest_advanced_search_bedroom
    bedrooms=["beds-2", "beds-3"]
    login()
    for  room in bedrooms
      @driver.get(@url + "/search/results?displayMode=search&location=90045&minRent=100&floorPlanTypes=0")
      @driver.find_element(:css, "#results-filter-beds > summary > div.details-toggle > span.icon.i-triangle-right-blue").click
      @driver.find_element(:id, room).click
      @driver.find_element(:id, "results-filter-submit-bottom").click
      sleep 4
      bedrooms_= (@driver.find_elements(:css,"p.prop-beds-baths-pets > span.prop-beds"))
      for b in bedrooms_
        puts (b.text), b[0]
        assert_includes(room.strip[5],((b.text).strip[0]))
      end
    end
  end

  def mtest_advanced_search_pets
    pets=["pets-cats-dogs"]
    login()
    for  pet in pets
      @driver.get(@url + "/search/results?displayMode=search&location=91367&minRent=100&floorPlanTypes=0")
      @driver.find_element(:css, "#results-filter-petpolicy > summary").click
      @driver.find_element(:id, pet).click
      @driver.find_element(:id, "results-filter-submit-bottom").click
      sleep 4
      pet_= (@driver.find_elements(:css,".i-cat"))
      for p in pet_
        puts (p.text)
        assert_includes((p.text),"Cats",)

      end
    end
  end

  def mtest_advanced_search_no_pets
    pets=["pets-none"]
    login()
    for  pet in pets
      @driver.get(@url + "/search/results?displayMode=search&location=91367&minRent=100&floorPlanTypes=0")
      @driver.find_element(:css, "#results-filter-petpolicy > summary").click
      @driver.find_element(:id, pet).click
      @driver.find_element(:id, "results-filter-submit-bottom").click
      sleep 4
      pet_= (@driver.find_elements(:css,".prop-beds-baths-pets"))
      for p in pet_
        puts (p.text)
        assert_not_equal((p.text),"Cats",)

      end
    end
  end


  def mtest_search_banding
    login()
    sleep 2
    #@driver.navigate(@url+'/search/results/')
    @driver.get(@url+'/search/results/')
    @driver.find_element(:id, "search-near").clear
    @driver.find_element(:css,"#search-near").send_keys @search_zipcode
    @driver.find_element(:css, "button.btn.btn-search").click
    banding= @driver.find_element(:css,".results-section").text
    assert_equal(banding, "Properties near " +@search_zipcode)

  end

  def test_pdp_page_without_a_cookie
    @driver.get(@url + "/")
    #@driver.find_element(:css, "button.btn.cancel").click
    @driver.find_element(:id, "freeform_submarket_nm").clear
    @driver.find_element(:id, "freeform_submarket_nm").send_keys "90278"
    @driver.find_element(:css, "button.btn.cancel").click
    sleep 4
    @driver.find_element(:css, "img")[2].click
    sleep 4
    @driver.find_element(:link, "Next").click
    @driver.find_element(:xpath, "(//input[@name='email'])[3]").clear
    @driver.find_element(:xpath, "(//input[@name='email'])[3]").send_keys "test1ccc458dd7@test.com"
    @driver.find_element(:xpath, "//input[@value='Create a Free Account']").click
    sleep 4
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys "test"
    @driver.find_element(:link, "Submit").click


  end

  def mtest_altreg_lopdp
    @driver.get(@url + "/")
    @driver.find_element(:id, "freeform_submarket_nm").clear
    @driver.find_element(:id, "freeform_submarket_nm").send_keys "Anaheim, CA"
    @driver.find_element(:css, "button.btn.cancel").click
    @driver.find_element(:link, "Canyon Village").click
    sleep 5
    @driver.find_element(:css, "a.next").click
    sleep 5
    @driver.find_element(:xpath, "//input[@placeholder='Your email is never shared with third-parties']").send_keys @email_address
    sleep 5
    @driver.find_element(:xpath, "//input[@value='Create a Free Account']").click
    sleep 5
    password_field = @driver.find_element(:id, "password")
    password_field.clear
    password_field.send_keys @password
    sleep 5
    @driver.find_element(:link, "Submit").click
    expected_signin = @driver.find_element(:xpath => "//span[@class='acct-email']")
    assert_equal( expected_signin.text, @email_address )
    @driver.find_element(:css, "span.acct-email").click
    @driver.find_element(:link, "Sign Out").click
  end
end