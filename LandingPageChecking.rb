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

    #Selenium::WebDriver::Firefox.path = "/usr/bin/google-chrome"
 #   prefs = {
  #  :download => {
   # :prompt_for_download => false, 
   # :default_directory => "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome2323"
  #}
#}
Selenium::WebDriver::Safari.path = "/Users/Shared/Jenkins/Library/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
      @driver = Selenium::WebDriver.for :chrome

        #@driver = Selenium::WebDriver.for :firefox
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
    sleep 5
    #(@driver.find_element(:xpath,"//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text).should == "SIGN U12P"
    verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text).should == "SIGN UP" }
    verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[4]/a").text).should == "LOG IN" }
    #puts(@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text)
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
