require 'json'
require 'selenium-webdriver'
require "rspec"
class ApplicationHelper

  driver = ""
  #@base_url = 'http://uat-portal.blutrumpet.com/'
  #@appName =  "App - ".concat(Array.new(10){rand(10).to_s(10)}.join)
  #@appURLBase = "https://play.google.com/store/apps/details?id=com"
  #@appURL = (@appURLBase.concat(@appName).concat("com")).to_str()
  #@appIconName = "Application Icon"
=begin
  def do_something
    @one = 2
  end
  def output
    puts @one
  end
=end

  def do_login (driver)

    driver.get('http://uat-portal.blutrumpet.com/b/site/index.html')
    driver.find_element(:link, 'LOG IN').click
    driver.find_element(:name, 'client[email]').clear
    driver.find_element(:name, 'client[email]').send_keys 'sebin@blutrumpet.com'
    driver.find_element(:name, 'client[password]').click
    driver.find_element(:name, 'client[password]').clear
    driver.find_element(:name, 'client[password]').send_keys 'jan@2014'
    driver.find_element(:xpath, "(//input[@value='SUBMIT'])[2]").click
    !60.times{ break if (element_present?(:id, 'userName') rescue false); sleep 1 }
    sleep 10

    verify { (driver.find_element(:id, 'userName').text).should == 'Sebin Baby'}
    verify { (driver.title).should == 'BluTrumpet Admin'}
    verify { (driver.find_element(:css, 'button.drkGrey').text).should == "FILTER" }
    verify { (driver.find_element(:css, 'div.chartHdr').text).should == "Application Earn" }
    verify { (driver.find_element(:css, 'div.chartCell.right > div.chartHdr').text).should == "Campaign Spend" }
    verify { (driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[5]/div").text).should == "Campaign Installs" }
    verify { (driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[4]/div").text).should == "Campaign Impressions" }

  end

end

instance = ApplicationHelper.new
#instance.do_login(Selenium::WebDriver.for :firefox)
