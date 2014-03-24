require 'rubygems'
require "selenium-webdriver"
require "rspec"
require 'spreadsheet'
include RSpec::Expectations

describe "AppwallTesting" do

  before(:all) do

    Selenium::WebDriver::Firefox::Binary.path = '/Applications/Firefox.app/Contents/MacOS/firefox-bin'
    
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage().window().maximize()

    @base_url = "https://via.appia.com/login.html"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    
    
    
    @dest_folder = File.dirname(__FILE__)
    @dateTime = ((Time.new).strftime("%Y-%m-%d %H.%M")).to_s
    @modifiedFile = "/Users/sebibbaby/Google Drive/QA/Automation Test Results/Partner Campaign Analysis/Appia/#{@dateTime}.xls"
    @book = Spreadsheet.open('/Users/sebibbaby/Google Drive/QA/SQL Scripts/Exports/Appia_Camp_Status.xls')
    @sheet1 = @book.worksheet(0)
   # @sheet2 = @book.worksheet(1)
    @xcelarr = []
    @allActiveCamp = []
    #@numberOfGames = []
    @sheet1[0,7] = "Appia Status"
 
  end
  
  after(:all) do
    @driver.quit
    #FileUtils.cp(@modifiedFile, @dest_folder)
  end


  it "Checking" do
    
    gettingDataFromXml
    
    #puts @xcelarr
    
    @driver.get(@base_url)
    @wait.until { @driver.find_element(:xpath => "//*[@id='emailAddress']").displayed? }
    @driver.find_element(:xpath, "//*[@id='emailAddress']").clear
    @driver.find_element(:xpath, "//*[@id='emailAddress']").click
    @driver.find_element(:xpath, "//*[@id='emailAddress']").send_keys "hsipe@breaktimestudios.com"
    
    @driver.find_element(:xpath, "//*[@id='password']").clear
    @driver.find_element(:xpath, "//*[@id='password']").click
    @driver.find_element(:xpath, "//*[@id='password']").send_keys "appia123"
    
    @driver.find_element(:xpath, "//*[@id='loginButton']").click
    @wait.until { @driver.find_element(:xpath => "html/body/nav/div[2]/ul[1]/li[1]/a").displayed? }
    
    @driver.get("https://via.appia.com/manualDashboard.html")
    
    @wait.until { @driver.find_element(:xpath => "//*[@id='filters']/div[2]/div/button").displayed? }
    
    @driver.find_element(:xpath, "//*[@id='viewAll']").click
    #while @driver.find_element(:xpath=>"//*[@id='viewAll").displayed?
    #end
    
    sleep 20
    getdata
    
    comparing
    
    matchwite
    
    @book.write @modifiedFile
  end


  def gettingDataFromXml
  
  @sheet1.each 1 do |row|
  break if row[0].nil? # if first cell empty
  @xcelarr<< row[1].to_s
 
     end
  end
  
  def getdata
    
    numberOfGames = @driver.find_elements(:xpath,"//*[@id='campaigns']/tbody/tr").size()
    puts numberOfGames
    if numberOfGames > 0
       for i in 1..numberOfGames
         #lastrow= @sheet2.last_row_index
          status = @driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[2]").text
          id = @driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[3]").text
          name = @driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[4]").text
        
        
          @allActiveCamp<<id
      end
    end
  end


  def comparing
    
    puts '...............'
    puts @allActiveCamp.length
    @xcelarr.each_with_index  do |id,index|
      #puts @allActiveCamp
      if @allActiveCamp.include? id
        @sheet1[index+1,7] = "Active"
         else
            @sheet1[index+1,7] = "Paused"
        end
    end
    
  end


    def matchwite
      
      @sheet1.each 1 do |row|
      break if row[0].nil?
      
        if(row[6] == row[7])
            row[8] = "Match"
        else 
            row[8] = "Mismatch"   
      end 
     end 
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
