require 'json'
require 'selenium-webdriver'
require "rspec"
#require 'spec'
include RSpec::Expectations
#require './lib/Common.rb'


describe 'App' do

  # Init Test
  before(:all) do

    @driver = Selenium::WebDriver.for :firefox
    @driver.manage().window().maximize()
    @base_url = 'http://uat-portal.blutrumpet.com/'
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
=begin
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['platform'] = "Windows 8.1"
    caps['version'] = "26"
    caps[:name] = "Application "

    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://btsauce:3d284ce4-ce68-4128-acc2-da28928ff141@ondemand.saucelabs.com:80/wd/hub",
        :desired_capabilities => caps)
    @driver.file_detector = lambda do |args|
      # args => ["/path/to/file"]
      str = args.first.to_s
      str if File.exist?(str)
    end
=end
    @base_url = "http://uat-portal.blutrumpet.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []

    AppName = Array.new(10){rand(10).to_s(10)}.join
    AppURLBase = "https://play.google.com/store/apps/details?id=com"
    AppURL = (AppURLBase.concat(AppName).concat("com")).to_str()
    AppIconName = "Application Icon"
    AppNameEditted = AppName+" Editted"
    NewAppNameForEdit = Array.new(7){rand(7).to_s(7)}.join
    NewAppURL = "https://play.google.com/store/apps/details?id=com".concat(" Adding ").concat(NewAppNameForEdit).concat("com")
    GeneralErrorMessage = "Please ensure all fields marked as required are filled or have a valid selection."
    ErrorMessageForIconUnit = "Please ensure creatives are uploaded where you have specified a creative name."
    ErrorAppFilter = "The URL under the App Filtering section cannot be the same as the URL for the App Store."
    ErrorMessageIntertitialunit = "Please specify an image for Portrait and Landscape for the Interstitial Ad Unit."


  end


  #do these steps after all
  after(:all) do

    @verification_errors.should == []
    #@driver.get(@base_url + "/b/apps.html")
    #sleep 20

#    # Log out
 #   @driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/img").click
  #  @driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/div/div[5]").click
   # sleep 5
    #(@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text).should == "SIGN UP"
    #(@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[4]/a").text).should == "LOG IN"

    @driver.quit

  end


  #login into the system before doing anything.
  it "test_Init_login" do

    puts("\n\n........................Login App.....................")
    @driver.get(@base_url + '/b/site/index.html')
    @driver.find_element(:link, 'LOG IN').click
    @driver.find_element(:name, 'client[email]').clear
    @driver.find_element(:name, 'client[email]').send_keys 'sebin@blutrumpet.com'
    @driver.find_element(:name, 'client[password]').click
    @driver.find_element(:name, 'client[password]').clear
    @driver.find_element(:name, 'client[password]').send_keys 'jan@2014'
    @driver.find_element(:xpath, "(//input[@value='SUBMIT'])[2]").click

    !60.times{ break if (element_present?(:id, 'userName') rescue false); sleep 1 }
    sleep 5

    verify { (@driver.find_element(:id, 'userName').text).should == 'Sebin Baby'}
    verify { (@driver.title).should == 'BluTrumpet Admin'}
    verify { (@driver.find_element(:css, 'button.drkGrey').text).should == "FILTER" }
    verify { (@driver.find_element(:css, 'div.chartHdr').text).should == "Application Earn" }
    verify { (@driver.find_element(:css, 'div.chartCell.right > div.chartHdr').text).should == "Campaign Spend" }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[5]/div").text).should == "Campaign Installs" }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[4]/div").text).should == "Campaign Impressions" }

  end


  #Creation App landing page checking
  it 'Creation_Page_should_populate_All_The_Fields ' do

    @driver.get(@base_url + "/b/app.html")
    sleep 10
    #Checking App platform drop-down
    puts("............................Checking App platform drop-down....................")
    app_platform = @driver.find_element(:xpath, "//*[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select")
    select_list = Selenium::WebDriver::Support::Select.new(app_platform)
    verify { select_list.select_by(:text, "Universal iOS")}

    #Checking App store drop-down
    puts("..............................Checking App store drop-down.....................")
    app_platform = @driver.find_element(:xpath, "//*[@id='store']")
    select_list = Selenium::WebDriver::Support::Select.new(app_platform)
    verify { select_list.select_by(:text, "Apple Store")}

  end



  #Should_Not_Create_App_When_AppName_Is_Empty
  it 'Should_Not_Create_App_When_AppName_Is_Empty ' do

    puts("...........................Should_Not_Create_App_When_AppName_Is_Empty...................")

    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys nil  # Passing empty value to App name
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end



  #Should_Not_Create_App_When_AppURL_Is_Empty
  it 'Should_Not_Create_App_When_AppURL_Is_Empty ' do

    puts("...........................Should_Not_Create_App_When_AppURL_Is_Empty..................")

    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys nil # Passing empty value to App URL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end



  #Should_Not_Create_App_When_AppTitle_Is_Empty
  it 'Should_Not_Create_App_When_AppTitle_Is_Empty ' do

    puts("...........................Should_Not_Create_App_When_AppTitle_Is_Empty...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 2
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys nil # Passing empty value to the app title
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end


  #Should_Not_Create_App_When_Category_Is_Empty
  it 'Should_Not_Create_App_When_Category_Is_Empty ' do

    puts("...........................Should_Not_Create_App_When_Category_Is_Empty...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 2
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end



  #Should_Not_Create_App_When_Geographic Type_Is_Empty
  it 'Should_Not_Create_App_When_Geographic Type_Is_Empty ' do

    puts("...........................Should_Not_Create_App_When_Geographic Type_Is_Empty...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end


  #Should_Not_Create_App_When_AppURL_Is_Invalid
  it 'Should_Not_Create_App_When_AppURL_Is_Invalid' do

    puts("...........................Should_Not_Create_App_When_AppURL_Is_Invalid...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys "www.invalid_url.com"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 3
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end


  #Should_Not_Create_App_When_AppURL_Is_Not_Valid_For_Selected_AppStore
  it 'Should_Not_Create_App_When_AppURL_Is_Not_Valid_For_Selected_AppStore' do

    puts("...........................Should_Not_Create_App_When_AppURL_Is_Not_Valid_For_Selected_AppStore...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL # Selected iOS and put Android URL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end


  #Should_Not_Create_App_When_Target_Countries_Are_Empty
  it 'Should_Not_Create_App_When_Target_Countries_Are_Empty ' do

    puts("...........................Should_Not_Create_App_When_Target_Countries_Are_Empty...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 2
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"custom\"]").click  # Selecting 'custom' from 'geographic type' so we need to specify the custom targeted countries.

    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end


  #Should_Not_Create_App_When_Target_Countries_Are_Invalid
  it 'Should_Not_Create_App_When_Target_Countries_Are_Invalid ' do

    puts("...........................Should_Not_Create_App_When_Target_Countries_Are_Invalid...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"custom\"]").click
    @driver.find_element(:xpath ,".//*[@id='country_chosen']/ul").send_key "somthing" # Putting some invalid data on target conutries box
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_App_When_Icon_Unit_Has_Name_Only
  it 'Should_Not_Create_App_When_Icon_Unit_Has_Name_Only' do

    puts("...........................Should_Not_Create_App_When_Icon_Unit_Has_Name_Only...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    @driver.find_element(:css, "input.renderedText.iconTitle").clear
    @driver.find_element(:css, "input.renderedText.iconTitle").send_keys AppIconName
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == ErrorMessageForIconUnit  || GeneralErrorMessage

  end

  #Should_Not_Create_App_When_Icon_Unit_Has_Icon_Only
  it 'Should_Not_Create_App_When_Icon_Unit_Has_Icon_Only' do

    puts("...........................Should_Not_Create_App_When_Icon_Unit_Has_Icon_Only...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 2
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click

    #upload file
    uploadPoint =  @driver.find_element(:xpath, "//*[@id='pageForm']/div/div[5]/div/div/div/div/table/tbody/tr[2]/td[2]/div/div/input")
    file = filepath("assets/".concat(rand(8).to_s.concat(".jpg")))
    puts(file)
    uploadPoint.send_keys(file)

    @driver.find_element(:css, "input.renderedText.iconTitle").clear
    @driver.find_element(:css, "input.renderedText.iconTitle").send_keys nil
    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == GeneralErrorMessage

  end



  it 'Remove_Creative_Button_Should_Be_Inactive_When_There_Is_Only_One_Creative' do


  end


  #Should not allow user to create an app using same url for both filter and app store url
  it 'Should not allow user to create an app using same url for both filter and app store url' do

    puts("...........................Should not allow user to create an app using same url for both filter and app store url...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    @driver.find_element(:xpath,"(//input[@type='text'])[6]").click
    @driver.find_element(:xpath,"(//input[@type='text'])[6]").send_key "AppFilter"
    @driver.find_element(:xpath,"(//input[@type='text'])[7]").send_key AppURL

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == ErrorAppFilter || GeneralErrorMessage || ErrorMessageIntertitialunit || ErrorMessageForIconUnit
  end


  #Should_Not_Create_App_When_Interstitial_Unit_For_Phone_Has_Name_Only
  it 'Should_Not_Create_App_When_Interstitial_Unit_For_Phone_Has_Name_Only' do

    puts("...........................Should_Not_Create_App_When_Interstitial_Unit_For_Phone_Has_Name_Only...................")
    @driver.get(@base_url + "/b/app.html")
    sleep 10
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
    @driver.find_element(:xpath, "(//option[@value=''])[2]").click
    @driver.find_element(:id, "appName").clear
    @driver.find_element(:id, "appName").send_keys AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName
    @driver.find_element(:id, "appUrl").clear
    @driver.find_element(:id, "appUrl").send_keys AppURL
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
    @driver.find_element(:css, "option[value=\"15\"]").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click
    @driver.find_element(:xpath,"(//input[@type='text'])[9]").send_key "Phone Interstitial"

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    (@driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]").text).should == ErrorMessageIntertitialunit || ErrorAppFilter

  end


  it "Should_Create_App_When_All_The_Informations_Are_Valid" do

      puts("...........................Should_Create_App_When_All_The_Informations_Are_Valid...................")
      @driver.get(@base_url + "/b/apps.html")
      verify { (@driver.find_element(:id, "filterApps").attribute("value")).should == "" }
      verify { (@driver.find_element(:css, "div.tabItem.activeItem > div.label").text).should == "iOS" }
      verify { (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[3]/div[1]/button").text).should == "Add App" }

      @driver.find_element(:css, "button.greenLarge.navItem").click
      sleep 3
      verify { (@driver.find_element(:id, "store").text).should == "Apple Store\nGoogle Play\nAmazon AppStore" }
      sleep 3
     verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Universal iOS\niPhone\niPad" }
      Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")

     @driver.find_element(:xpath, "(//option[@value=''])[2]").click
 #     (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android"
      Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Amazon AppStore")
      @driver.find_element(:css, "option[value=\"amazon\"]").click

      verify { (@driver.find_element(:xpath, "//form[@id='pageForm']/div/table/tbody/tr[3]/td[2]/select").text).should == "Android" }
      Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "store")).select_by(:text, "Google Play")
      @driver.find_element(:xpath, "(//option[@value=''])[2]").click


      @driver.find_element(:id, "appName").clear
      @driver.find_element(:id, "appName").send_keys AppName
      @driver.find_element(:id, "appTitle").clear
      @driver.find_element(:id, "appTitle").send_keys AppName
      @driver.find_element(:id, "appUrl").clear
      @driver.find_element(:id, "appUrl").send_keys AppURL


      Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Reference")
      @driver.find_element(:css, "option[value=\"15\"]").click

      Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
      @driver.find_element(:css, "option[value=\"world\"]").click
      sleep 3

      #upload file for creative ....

      uploadPoint =  @driver.find_element(:xpath, "//*[@id='pageForm']/div/div[5]/div/div/div/div/table/tbody/tr[2]/td[2]/div/div/input")
      file = filepath("assets/".concat(rand(8).to_s.concat(".jpg")))
      puts(file)
      uploadPoint.send_keys (file)

      sleep 3

      @driver.find_element(:css, "input.renderedText.iconTitle").clear
      @driver.find_element(:css, "input.renderedText.iconTitle").send_keys AppIconName


      @driver.find_element(:css, "button.greenLarge.submitForm").click
      !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
      sleep 20
      @driver.find_element(:id, "filterApps").click
      @driver.find_element(:id, "filterApps").send_keys AppName, :enter
      !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
      (@driver.find_element(:link, AppName).text).should == AppName

      @driver.find_element(:link, AppName).click
      sleep 10
      (@driver.find_element(:id, "appName").attribute("value")).should == AppName
      (@driver.find_element(:id, "appTitle").attribute("value")).should == AppName
      (@driver.find_element(:id, "appUrl").attribute("value")).should == AppURL


      @driver.find_element(:css, "button.grey.navItem").click

  end

  it 'Should_Edit_AppTitle_While_Editing_The_App' do

    puts("...........................Should_Edit_AppTitle_While_Editing_The_App...................")
    sleep 3
    @driver.find_element(:link, AppName).click
    sleep 10
    (@driver.find_element(:id,"appName").attribute("value")).should == AppName
    @driver.find_element(:id, "appTitle").clear
    @driver.find_element(:id, "appTitle").send_keys AppName+"Editted"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Finance")
    @driver.find_element(:css, "option[value=\"5\"]").click

    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "US Only")
    @driver.find_element(:css, "option[value=\"us\"]").click

    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 10

    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys AppName, :enter
    !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
    (@driver.find_element(:link, AppName).text).should == AppName
    @driver.find_element(:link, AppName).click
    sleep 5

    verify { (@driver.find_element(:css, "td.labelguid").text).should == "Your Application ID" }
    @driver.find_element(:xpath, "//form[@id='pageForm']/div/div[8]/button").click
    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    sleep 15
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys AppName,:enter

    !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
    (@driver.find_element(:link, AppName).text).should == AppName

    @driver.find_element(:link, AppName).click
    sleep 10
    (@driver.find_element(:id, "appName").attribute("value")).should == AppName

    categoryDrop_DownValue = checking_the_dropdown_Value("category")
    categoryDrop_DownValue.should == "Finance"
    geographicTypeDrop_DownValue = checking_the_dropdown_Value("geographyType")
    geographicTypeDrop_DownValue.should == "US Only"

    @driver.find_element(:css, "button.grey.navItem").click

  end

  it 'Should_Edit_AppURL_While_Editing_The_App' do

    puts("...........................Should_Edit_AppURL_While_Editing_The_App...................")
    sleep 15
    @driver.find_element(:link, AppName).click
    sleep 10
    @driver.find_element(:id,"appUrl").click
    @driver.find_element(:id,"appUrl").clear
    @driver.find_element(:id,"appUrl").send_key NewAppURL

    sleep 2
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "News")
    @driver.find_element(:css, "option[value=\"12\"]").click

    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 10

    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys AppName, :enter
    !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
    (@driver.find_element(:link, AppName).text).should == AppName
    @driver.find_element(:link, AppName).click
    sleep 5

    verify { (@driver.find_element(:css, "td.labelguid").text).should == "Your Application ID" }
    @driver.find_element(:xpath, "//form[@id='pageForm']/div/div[8]/button").click
    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    sleep 15
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys AppName,:enter

    !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
    (@driver.find_element(:link, AppName).text).should == AppName

    @driver.find_element(:link, AppName).click
    sleep 10
    (@driver.find_element(:id,"appUrl").attribute("value")).should == NewAppURL
    @driver.find_element(:css, "button.grey.navItem").click

  end


  it 'Should_Edit_Category_While_Editing_The_App' do

    puts("...........................Should_Edit_Category_While_Editing_The_App...................")
    sleep 15
    @driver.find_element(:link, AppName).click
    sleep 15

    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Sports")
    @driver.find_element(:css, "option[value=\"19\"]").click

    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 10

    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys AppName, :enter
    !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
    (@driver.find_element(:link, AppName).text).should == AppName
    @driver.find_element(:link, AppName).click
    sleep 5

    categoryDrop_DownValue = checking_the_dropdown_Value("category")
    categoryDrop_DownValue.should == "Sports"

    @driver.find_element(:css, "button.grey.navItem").click

  end


  #Should_Edit_Geography_Type_While_Editing_The_App
  it 'Should_Edit_Geography_Type_While_Editing_The_App' do

    puts("...........................Should_Edit_Geography_Type_While_Editing_The_App...................")
    sleep 15
    @driver.find_element(:link, AppName).click
    sleep 15

    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "World")
    @driver.find_element(:css, "option[value=\"world\"]").click

    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 10

    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys AppName, :enter
    !60.times{ break if (element_present?(:link, AppName) rescue false); sleep 1 }
    (@driver.find_element(:link, AppName).text).should == AppName
    @driver.find_element(:link, AppName).click
    sleep 15

    geographicTypeDrop_DownValue = checking_the_dropdown_Value("geographyType")
    geographicTypeDrop_DownValue.should == "World"

    @driver.find_element(:css, "button.grey.navItem").click

  end



  it "Should_Be_Able_To_Edit_AppName" do

        puts("...........................Should_Be_Able_To_Edit_AppName...................")
        sleep 15
        @driver.find_element(:link, AppName).click
        sleep 15
        !60.times{ break if (element_present?(:id, "appName") rescue false); sleep 1 }
        @driver.find_element(:id, "appName").clear

        @driver.find_element(:id, "appName").send_keys AppNameEditted
        @driver.find_element(:id, "appTitle").clear
        @driver.find_element(:id, "appTitle").send_keys AppNameEditted
        Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "category")).select_by(:text, "Finance")
        @driver.find_element(:css, "option[value=\"5\"]").click

        Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "geographyType")).select_by(:text, "US Only")
        @driver.find_element(:css, "option[value=\"us\"]").click

        sleep 3
        @driver.find_element(:css, "button.greenLarge.submitForm").click
        sleep 10

        !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
        @driver.find_element(:id, "filterApps").click
        @driver.find_element(:id, "filterApps").send_keys AppNameEditted, :enter
        !60.times{ break if (element_present?(:link, AppNameEditted) rescue false); sleep 1 }
        (@driver.find_element(:link, AppNameEditted).text).should == AppNameEditted
        @driver.find_element(:link, AppNameEditted).click
        sleep 5

        #verify { (@driver.find_element(:xpath,"//*[@id='geographyType").find('option[selected]').text).should == "Finance"}

        verify { (@driver.find_element(:css, "td.labelguid").text).should == "Your Application ID" }
        @driver.find_element(:xpath, "//form[@id='pageForm']/div/div[8]/button").click
        !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
        sleep 15
        @driver.find_element(:id, "filterApps").click
        @driver.find_element(:id, "filterApps").send_keys AppNameEditted,:enter

        !60.times{ break if (element_present?(:link, AppNameEditted) rescue false); sleep 1 }
        (@driver.find_element(:link, AppNameEditted).text).should == AppNameEditted

  end

  #Should_Be_Able_To_Delete_The_Application
  it 'Should_Be_Able_To_Delete_The_Application ' do

    puts("...........................Should_Be_Able_To_Delete_The_Application...................Not Implemented")
    sleep 2

    #@driver.find_element(:css, "a.delete_application > img.icon").click
    #@driver.switch_to.alert.accept

#    sleep 7

 #   @driver.find_element(:xpath, "//*[@id='filterApps']").click
  #  @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys "0075048886", :enter
   # sleep 5

end

  #Getting the drop-down value
  def checking_the_dropdown_Value(id)

    dropdown = @driver.find_element(:id,id)
    select_list = Selenium::WebDriver::Support::Select.new(dropdown)
    return select_list.selected_options[0].text

  end


  #Checking the Application view page
  it 'Checking_Application_View_Page' do

    @driver.get(@base_url + "/b/apps.html")
    puts("...........................Checking_Application_View_Page...................")
    sleep 10
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").clear
    @driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]/div[1]").text.should == "iOS"
    @driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]/div[2]").text.should == "Google Play"
    @driver.find_element(:xpath,"//*[@id='pgWrap']/div[3]/div[2]/div[3]").text.should == "Amazon"

  end


  def filepath filename

    File.expand_path(File.join(File.dirname(__FILE__), filename))

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
