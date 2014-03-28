require "json"
require 'rubygems'
require "selenium-webdriver"
require "rspec"
require 'countries'
include RSpec::Expectations

describe "AppwallTesting" do

  before(:each) do
    
    
    #path = "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    #Selenium::WebDriver::Chrome.path = "/usr/bin/chromedriver"
    Selenium::WebDriver::Chrome.path = "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    @driver = Selenium::WebDriver.for :safari
    @driver.manage().window().maximize()

    @base_url = "http://apps.blutrumpet.com/products/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    
    #To create files for each platform to write the summary of the test.. 
    dateTime = ((Time.new).strftime("%Y-%m-%d %H.%M")).to_s
    @filenameAndroid = "/Users/sebibbaby/Google Drive/QA/Automation Test Results/AppWall/#{dateTime}_Android"
    @filenameiOS = "/Users/sebibbaby/Google Drive/QA/Automation Test Results/AppWall/#{dateTime}_ipad"
    @filenameiphone = "/Users/sebibbaby/Google Drive/QA/Automation Test Results/AppWall/#{dateTime}_iphone"
    
    #Getting the list of countries - Total 250 countries.
    @listOfCountries = Country.all    #[["au","au"],["nz","nz"],["xx","xx"]]#Country.all
    
    #Array to store the Appwalls displaying along with countries.
    @ListOfCountriesHaveApp = []
    @ListOfCountriesHaventApp = []
    
    #Country Count
    @CountPlus = 0
    @Countminus = 0
    
    #Building the URL with MaxOS version
    @AndroidMaxOSVersion = "&passthrough%5Bc.useros%5D=6.0"
    @iPadMaxOSVersion = "&passthrough%5Bc.useros%5D=7.0"
    @iPhoneMaxOSVersion = "&passthrough%5Bc.useros%5D=7.0"
    
    #Listing country by region----
    #list = Country.find_all_countries_by_region('Americas','Asia')
    #c = list[1].alpha2
    #puts(list[1])
    #puts(list)
    
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should = []
    @ListOfCountriesHaveApp.clear
    @ListOfCountriesHaventApp.clear
  end
    
=begin
  Init... 
  This method contains only functions to generate 
  different URLs and summary for each platform...
  1.Android
  2.ipad
  3.iphone
=end  
  it "CheckingForEachPlatforms" do
    
    puts('.....................Checking .....................')
  
    #Creating the URL for android 
    gettingUrl(@filenameAndroid,"Android",@AndroidMaxOSVersion) 
    summaryWrite(@filenameAndroid)
    sleep 2
    
    #Creating the URL for android 
    gettingUrl(@filenameiOS,"ipad",@iPadMaxOSVersion)
    summaryWrite(@filenameiOS)
    #sleep 2
    
    #Creating the URL for android 
    gettingUrl(@filenameiphone,"iphone",@iPhoneMaxOSVersion)
    summaryWrite(@filenameiphone)
    sleep 2
    
  end   
    
  #This method will generate the url 
  def gettingUrl(filename,value,osVersion)
   
    @listOfCountries.each do |d| 
    @url = @base_url +value+"/sample?debug&passthrough%5Bcountry_code%5D="+d[1]+osVersion
    @driver.get(@url)
    sleep 3
    
    #Opening/creating files to write the result
    File.open(filename+".txt", 'a') {|f| f.write(d[0] + " - "+ d[1]) }
    File.open(filename+".txt", 'a') {|f| f.write("\n") }
    File.open(filename+".txt", 'a') {|f| f.write("URL - ".concat(@url)) }
    File.open(filename+".txt", 'a') {|f| f.write("\n\n") }
    
    # Method returns the app count which is displaying on the screen. 
    gettingAppCount(filename,d[0]) 
    
    end
 end   
   
   #Returns app count for each country and write that info into appropriate  file. 
   def gettingAppCount(filename,country)
   
     numberOfGames = @driver.find_elements(:xpath,'//*[@id="main"]/ul/li').size()
     puts(numberOfGames)
     File.open(filename+".txt", 'a') {|f| f.write("Total Apps Displayed - ".concat(numberOfGames.to_s)) }
     File.open(filename+".txt", 'a') {|f| f.write("\n\n") }
     
      if numberOfGames > 0
        value = country.to_s+" (#{numberOfGames})"  
        @ListOfCountriesHaveApp<< value
        @CountPlus+=1
        
          for i in 1..numberOfGames
            appName = @driver.find_element(:xpath, "//*[@id='main']/ul/li[#{i}]/h1").text
            @new = appName+ "\n"
            File.open(filename+".txt", 'a') {|f| f.write(@new) }
          end
      end
         
      if numberOfGames == 0
        @ListOfCountriesHaventApp<< country
        @Countminus+=1
      end   
      
     File.open(filename+".txt", 'a') {|f| f.write("-------------------------------------------------------------------------------------------------") }
     File.open(filename+".txt", 'a') {|f| f.write("\n\n\n") }
   
    end
    
    #Writing the summary
    def summaryWrite(filename)
  
        File.open(filename+".txt", 'a') {|f| f.write("\n\n") }
        File.open(filename+".txt", 'a') {|f| f.write("-------------------------------Summary-------------------------------") }
        File.open(filename+".txt", 'a') {|f| f.write("\n") }
        File.open(filename+".txt", 'a') {|f| f.write("Number of Countries has Appwall " + "-  " + @CountPlus.to_s) }
        File.open(filename+".txt", 'a') {|f| f.write("\n") }    
        File.open(filename+".txt", 'a') do |s|
        @ListOfCountriesHaveApp.each { |element| s.puts(element) }
      end
          
        File.open(filename+".txt", 'a') {|f| f.write("\n") } 
        File.open(filename+".txt", 'a') {|f| f.write("Number of Countries not having Appwall " + "-  " + @Countminus.to_s) }
        File.open(filename+".txt", 'a') {|f| f.write("\n") }
        File.open(filename+".txt", 'a') do |c|
        @ListOfCountriesHaventApp.each { |element| c.puts(element) }
      end
      
        @CountPlus = 0 
        @Countminus = 0 
        @ListOfCountriesHaveApp.clear
        @ListOfCountriesHaventApp.clear
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
