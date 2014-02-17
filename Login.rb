require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations


describe "Login" do

  before(:all) do

caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['platform'] = "Windows 8.1"
    caps['version'] = "26"
    caps[:name] = "Login"

    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://btsauce:3d284ce4-ce68-4128-acc2-da28928ff141@ondemand.saucelabs.com:80/wd/hub",
        :desired_capabilities => caps)
        
   @base_url = "http://uat-portal.blutrumpet.com/"
   @accept_next_alert = true
   @driver.manage.timeouts.implicit_wait = 30
   @verification_errors = []
    


end


  after(:all) do
    @driver.quit
    @verification_errors.should == []
  end

  #Login into the system

  it "test_login" do

    puts('.....................Login checking.....................')
    @driver.get(@base_url + "/b/site/index.html")
    @driver.find_element(:link, "LOG IN").click
    @driver.find_element(:name, "client[email]").clear
    @driver.find_element(:name, "client[email]").send_keys "sebin@blutrumpet.com"
    @driver.find_element(:name, "client[password]").click
    @driver.find_element(:name, "client[password]").clear
    @driver.find_element(:name, "client[password]").send_keys "jan@2014"
    @driver.find_element(:xpath, "(//input[@value='SUBMIT'])[2]").click

    !60.times{ break if (element_present?(:id, "userName") rescue false); sleep 1 }
    sleep 10
    verify { (@driver.find_element(:id, 'userName').text).should == 'Sebin Baby'}

    (@driver.title).should == "BluTrumpet Admin"

    verify { (@driver.find_element(:css, "button.drkGrey").text).should == "FILTER" }
    verify { (@driver.find_element(:css, "div.chartHdr").text).should == "Application Earn" }
    verify { (@driver.find_element(:css, "div.chartCell.right > div.chartHdr").text).should == "Campaign Spend" }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[5]/div").text).should == "Campaign Installs" }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[4]/div").text).should == "Campaign Impressions" }

    puts('.....................SignOut.....................')
    @driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/img").click
    sleep 3
    @driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/div/div[5]").click
    sleep 5

    verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text).should == "SIGN UP" }
    verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[4]/a").text).should == "LOG IN" }

  end


  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
