require 'rubygems'
require "selenium-webdriver"
require "rspec"
require 'spreadsheet'
include RSpec::Expectations
require 'countries'

describe "AppiaCampAnalysisV4" do

  before(:all) do
    
    
    @driver = Selenium::WebDriver.for :firefox
    
    @driver.manage().window().maximize()

    @base_url = "https://via.appia.com/login.html"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @wait = Selenium::WebDriver::Wait.new(:timeout => 100)

    @dest_folder = File.dirname(__FILE__)
    dateTime = ((Time.now - (240 * 60 + 0)).strftime("%Y-%m-%d %H.%M")).to_s
    
    @modifiedFile = "/home/dev/GoogleDrive/QA/Automation Test Results/Partner Campaign Analysis/Appia/Appia_#{@dateTime}.xls"
    @book = Spreadsheet.open('/home/dev/GoogleDrive/QA/SQL Scripts/Exports/Appia_Camp_Status.xls')
    
    @sheet1 = @book.worksheet(0)
    
     @sheet1[0,8] = "Appia Status"
     @sheet1[0,10] = "Appia Payout"
     @sheet1[0,12] = "Appia Geo"
     @sheet1[0,16] = "Appia Platform"
     @sheet1[0,17] = "Appia Id"
   
 
      @xcelarr = []
      @allActiveCamp = []
      @platform =[]
      @geo = []
 
  end
  
  after(:all) do
    @driver.quit
  end

  def gettingDataFromExcel
  
      @sheet1.each 1 do |row|
      break if row[0].nil? # if first cell empty
      @xcelarr<< row[1].to_s
 
    end
  end
  
  it "Checking" do
    
    gettingDataFromExcel
    
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
    
    repeatForActiveAndPending("Active")
    sleep 3
    
    gettingGeosAndPlatforms
    
    camparingcells
    
    @book.write @modifiedFile
    FileUtils.cp(@modifiedFile, @dest_folder)
    
  end

  def repeatForActiveAndPending(stat)
      
    @driver.find_element(:xpath,"(//button[@type='button'])[4]").click
    sleep 2
    @driver.find_element(:link, stat).click
    sleep 5
    @driver.find_element(:xpath, "html/body/div[2]/div[1]/div/header/h1/span").click
    sleep 3
    
      if(stat=="Active")
       @wait.until { @driver.find_element(:xpath, "//*[@id='viewAll']").displayed? }
       @driver.find_element(:xpath, "//*[@id='viewAll']").click
       sleep 50
      end
      gettingDataFromAPI
  end
  
  def gettingDataFromAPI
    
    numberOfGames = @driver.find_elements(:xpath,"//*[@id='campaigns']/tbody/tr").size()
    puts numberOfGames
    if numberOfGames > 0
       for i in 1..numberOfGames
         
          status = @driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[2]").text
          id = @driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[3]").text
          name = @driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[4]").text
          payout = (@driver.find_element(:xpath, "//*[@id='campaigns']/tbody/tr[#{i}]/td[6]").text)[1..5].to_f

          @allActiveCamp<<id   
        end                       
     end
  end
    
  def gettingGeosAndPlatforms
    
    @xcelarr.each_with_index do |id,index|
      if @allActiveCamp.include? id
    
      @driver.get("https://via.appia.com/campaign.html?campaignId=#{id}")
      @wait.until{@driver.find_element(:xpath,"//*[@id='notification-switch']/div/label").displayed?}
      payout = (@driver.find_element(:xpath,"//*[@id='payouts-tab']/table/tbody/tr/td[2]").text)[1..5].to_f
      numberOfCountries = @driver.find_elements(:xpath,'//*[@id="countries"]/li').size()
       
          for i in 1..numberOfCountries
               cName = @driver.find_element(:xpath, "//*[@id='countries']/li[#{i}]").text
                      if cName =="Great Britain (UK)"
                        cName = "United Kingdom"
                     end
                     if cName =="Croatia (Hrvatska)"
                        cName = "Croatia"
                      end
                      
                      c = Country.find_country_by_name(cName)
                      @platform<<c.alpha2
                      
           end
           if @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[5]/td[1]").text == "Min OS Version"
               platform = @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[5]/td[2]").text
           else
               platform = @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[6]/td[2]").text
           end                                        
                  
           if @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[2]/td[2]").text =="iOS"
               get(index)
           else
              @sheet1[index+1,16] = "Android"
           end

        @sheet1[index+1,10] = payout
        @sheet1[index+1,12] = @platform.join(',')
        @sheet1[index+1,14] = platform
        @sheet1[index+1,17] = id
                   
        @sheet1[index+1,8] = "Active"
        @platform.clear
        @geo.clear
          
       else
      @sheet1[index+1,8] = "Paused"
     end
    end     
   end
   
   def get(index)
      if @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[8]/td[1]").text == "Excluded Devices"
          numberOfDevices = @driver.find_elements(:xpath,'html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[8]/td[2]/ul/li').size()
           
              for i in 1..numberOfDevices
                  pName = @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[8]/td[2]/ul/li[#{i}]").text
                  @geo<<pName
                      
              end
      else
        numberOfDevices = @driver.find_elements(:xpath,'html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[9]/td[2]/ul/li').size() 
              for i in 1..numberOfDevices
                  pName = @driver.find_element(:xpath, "html/body/div[2]/div[2]/div[2]/div/div[2]/table/tbody/tr[9]/td[2]/ul/li[#{i}]").text
                  @geo<<pName  
              end
      end 
      
      if @geo.include? 'Apple iPhone'
             @sheet1[index+1,16] = "iPad" 
      end
      
      if @geo.include? 'Apple iPad' 
            @sheet1[index+1,16] = "iPhone"
      end
      
      if @sheet1[index+1,16].nil?
            @sheet1[index+1,16] = "iPhone,iPad"
      end           
    end
          
    def camparingcells
        
      @sheet1.each_with_index 1 do |row,ind|
       break if row[0].nil?
  
        if(row[6] == row[8])
           row[9] = "Match"
       
        else
          row[9] = "MisMatch"
        end
            
        if (row[7].to_f == row[10].to_f)
        row[11] = "Match"
        else
        row[11] = "Mismatch"     
        end
          
        if(row[10].nil?) && (row[8] == "Paused")
        row[11]=""
        end
         
        conutryvalue = row[4].to_s.split(",")
        row12= row[12].to_s.downcase

        if((comp(row[4].to_s,row12,conutryvalue)) == 1)
        row[13] = "Match"
        else 
        row[13] = "Mismatch"
        end
           if(row[12].nil?)
             row[13]=""
           end 
        devicevalue = row[5].to_s.split(",")
        row16= row[16].to_s.downcase
        row5 = row[5].to_s.downcase

       #if((comp(row[5].to_s,row[16].to_s,devicevalue)) == 1) 
       if(row16.include? row5)
        row[15] = "Match"
      else
        row[15] = "Mismatch" 
      end
      if(row[16].nil?)
          row[15]=""
      end 
    end
 end

  def comp(str1,str2,str3)
    
     str3.each do |s|
      
      if(str2.include? s )&& (str1.length == str2.length)
        return 1 
      else
        return 0
     end
    end
  end                      
end
