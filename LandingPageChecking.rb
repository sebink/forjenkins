require "json"
require 'rubygems'
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations
#require_relative './lib/common.rb'
#require './spec/sauce_helper'


describe "LandingPageChecking" do

  before(:each) do

    #...........................For SauceLab..........................

=begin
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['platform'] = "Windows 8.1"
    caps['version'] = "26"
    caps[:name] = "Landing Page"

    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://btsauce:3d284ce4-ce68-4128-acc2-da28928ff141@ondemand.saucelabs.com:80/wd/hub",
        :desired_capabilities => caps)

    @base_url = "http://uat-portal.blutrumpet.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
=end
#............................For Local run ..........................
    #path1= "/Applications/Firefox.app/Contents/MacOS/firefox-bin"
    #Selenium::WebDriver::Firefox.path =  path1
    
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage().window().maximize()

    @base_url = "http://uat-portal.blutrumpet.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    

  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end

  it "test_landing_page_checking" do

    puts('.....................Checking Landing Page.....................')

    @driver.get(@base_url + "/b/site/index.html")

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
