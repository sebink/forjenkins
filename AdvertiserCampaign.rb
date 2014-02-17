require 'json'
require 'selenium-webdriver'
require 'rspec'
include RSpec::Expectations
require './App.rb'

describe 'AdvertiserCampaign' do

puts('Test Suite Changed --------Advertiser Campaign---------------')
  #Int test
  before(:all) do


    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['platform'] = "Windows 8.1"
    caps['version'] = "26"
    caps[:name] = "Advertiser Campaign "

    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://btsauce:3d284ce4-ce68-4128-acc2-da28928ff141@ondemand.saucelabs.com:80/wd/hub",
        :desired_capabilities => caps)

   @base_url = "http://uat-portal.blutrumpet.com/"
   @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []

    CampaignName = 'Advertiser Camp '.concat(Array.new(10){rand(10).to_s(10)}.join)

  end

  # do these steps before all
  after(:all) do

   # @verification_errors.should == []
   # @driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/img").click
   # @driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/div/div[5]").click
    #sleep 5

    #verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text).should == 'SIGN UP' }
    #verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[4]/a").text).should == 'LOG IN' }
    @driver.quit

  end

  #login into the system before doing anything.
  it 'test_Init_login' do

    puts("\n\n........................Login......................")
    @driver.get(@base_url + '/b/site/index.html')
    @driver.find_element(:link, 'LOG IN').click
    @driver.find_element(:name, 'client[email]').clear
    @driver.find_element(:name, 'client[email]').send_keys 'sebin@blutrumpet.com'
    @driver.find_element(:name, 'client[password]').click
    @driver.find_element(:name, 'client[password]').clear
    @driver.find_element(:name, 'client[password]').send_keys 'jan@2014'
    @driver.find_element(:xpath, "(//input[@value='SUBMIT'])[2]").click

    !60.times{ break if (element_present?(:id, 'userName') rescue false); sleep 1 }
    sleep 10

    verify { (@driver.find_element(:id, 'userName').text).should == 'Sebin Baby'}
    verify { (@driver.title).should == 'BluTrumpet Admin'}
    verify { (@driver.find_element(:css, 'button.drkGrey').text).should == 'FILTER' }
    verify { (@driver.find_element(:css, 'div.chartHdr').text).should == 'Application Earn' }
    verify { (@driver.find_element(:css, 'div.chartCell.right > div.chartHdr').text).should == 'Campaign Spend' }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[5]/div").text).should == 'Campaign Installs' }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[4]/div").text).should == 'Campaign Impressions' }

  end

  #Creation_Advertiser_Campaign_Landing_Page_Checking
  it '#Creation_Advertiser_Campaign_Landing_Page_Checking ' do

    puts('.....................Creation_Advertiser_Campaign_Landing_Page_Checking.....................')
    @driver.get(@base_url + '/b/advertiser_campaign.html')
    sleep 10
    time = Date.today
    formatedDate = time.strftime('%Y-%m-%d')
    (@driver.find_element(:xpath,"//*[@id='campaignName']").text).should == ''
    (@driver.find_element(:xpath,".//*[@id='appDescription']").text).should == ''
    @driver.find_element(:name, 'campaignStartDate').attribute('value').should == formatedDate
    (@driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[1]").text).should  == 'Basic Settings'
    (@driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[2]").text).should  == 'Financial'
    (@driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[3]").text).should  == 'Targeting'
    (@driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[4]").text).should  == 'Creatives'

    @driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    @driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath,"//div[@id='undefined-sticky-wrapper']/div/div[4]").click

  end

#Should_Not_Create_Campaign_When_CampaignName_Is_Empty
  it 'Should_Not_Create_Campaign_When_CampaignName_Is_Empty' do

    puts('.....................Should_Not_Create_Campaign_When_CampaignName_Is_Empty.....................')

    @driver.get(@base_url + '/b/advertiser_campaign.html')
    sleep 10
    @driver.find_element(:id, 'campaignName').clear
    @driver.find_element(:id, 'campaignName').send_keys ''
    @driver.find_element(:id, 'appDescription').clear
    @driver.find_element(:id, 'appDescription').send_keys 'Doing automation testing of advertiser campaign'
    sleep 20
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted
    }
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    time = Date.today + 1
    formatedDate = time.strftime('%Y-%m-%d')

    @driver.find_element(:name, 'campaignStartDate').clear
    @driver.find_element(:name, 'campaignStartDate').send_key formatedDate
    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, 'campaignBid').clear
    @driver.find_element(:name, 'campaignBid').send_keys '1'
    @driver.find_element(:id, 'dailymax').clear
    @driver.find_element(:id, 'dailymax').send_keys '12'
    @driver.find_element(:name, 'overallMax').clear
    @driver.find_element(:name, 'overallMax').send_keys '123'
    sleep 2
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen13']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key '2.1'
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == '2.1' }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[4]").click
    @driver.find_element(:name, 'ui_ad_type_2').click
    @driver.find_element(:css, 'button.greenLarge.submitForm').click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage


  end

#Should_Not_Create_Campaign_When_CampaignName_Is_Invalid
  it 'Should_Not_Create_Campaign_When_CampaignName_Is_Invalid' do

    puts('.....................Should_Not_Create_Campaign_When_CampaignName_Is_Invalid.....................')

    @driver.get(@base_url + '/b/advertiser_campaign.html')
    sleep 10
    @driver.find_element(:id, 'campaignName').clear
    @driver.find_element(:id, 'campaignName').send_keys ' '
    @driver.find_element(:id, 'appDescription').clear
    @driver.find_element(:id, 'appDescription').send_keys 'Doing automation testing of advertiser campaign'
    sleep 20
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted
    }
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    time = Date.today + 1
    formatedDate = time.strftime('%Y-%m-%d')

    @driver.find_element(:name, 'campaignStartDate').clear
    @driver.find_element(:name, 'campaignStartDate').send_key formatedDate

    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage


  end


#Should_Not_Create_Campaign_When_AppName_Is_Empty
it 'Should_Not_Create_Campaign_When_AppName_Is_Empty' do

  puts(".....................Should_Not_Create_Campaign_When_AppName_Is_Empty.....................")
  #puts(AppNameEditted)

  @driver.get(@base_url + "/b/advertiser_campaign.html")
  sleep 10
  @driver.find_element(:id, "campaignName").clear
  @driver.find_element(:id, "campaignName").send_keys CampaignName
  @driver.find_element(:id, "appDescription").clear
  @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
  sleep 20

  time = Date.today + 1
  formatedDate = time.strftime("%Y-%m-%d")

  @driver.find_element(:name,"campaignStartDate").clear
  @driver.find_element(:name, "campaignStartDate").send_key formatedDate


  financialSection
  sleep 10
  @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
  @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[4]").click


  @driver.find_element(:css, "button.greenLarge.submitForm").click
  sleep 20
  (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

end


#Should_Not_Create_Campaign_When_Campaign_Description_Is_Empty
  it 'Should_Not_Create_Campaign_When_Campaign_Description_Is_Empty' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_Description_Is_Empty.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys ""
    sleep 20
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    time = Date.today + 1
    formatedDate = time.strftime("%Y-%m-%d")

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedDate


    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end


#Should_Not_Create_Campaign_When_Campaign_Description_Is_Invalid
  it 'Should_Not_Create_Campaign_When_Campaign_Description_Is_Invalid' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_Description_Is_Invalid.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys " "
    sleep 20
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    time = Date.today + 1
    formatedDate = time.strftime("%Y-%m-%d")

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedDate


    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_Campaign_StartDate_Is_Empty
  it 'Should_Not_Create_Campaign_When_Campaign_StartDate_Is_Empty' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_StartDate_Is_Empty.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 15
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key ""


    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_Campaign_StartDate_Is_Invalid
  it 'Should_Not_Create_Campaign_When_Campaign_StartDate_Is_Invalid' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_StartDate_Is_Invalid.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 15
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key "9917"


    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end


  #Should_Not_Create_Campaign_When_Campaign_StartDate_Is_LessThan_Current_Date
  it 'Should_Not_Create_Campaign_When_Campaign_StartDate_Is_LessThan_Current_Date' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_StartDate_Is_LessThan_Current_Date.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 15
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    time = Date.today - 1
    formatedDate = time.strftime("%Y-%m-%d")

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedDate

    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_Campaign_StartDate_Is_GreaterThan_EndDate
  it 'Should_Not_Create_Campaign_When_Campaign_StartDate_Is_GreaterThan_EndDate' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_StartDate_Is_GreaterThan_EndDate.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 15
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    timeStartDate = Date.today + 1
    timeEndDate = Date.today - 3
    formatedStartDate = timeStartDate.strftime("%Y-%m-%d")
    formatedEndDate = timeEndDate.strftime("%Y-%m-%d")

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedStartDate

    @driver.find_element(:name,"campaignEndDate").clear
    @driver.find_element(:name, "campaignEndDate").send_key formatedEndDate

    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

#Should_Not_Create_Campaign_When_Campaign_StartDate_Is_GreaterThan_EndDate
  it 'Should_Not_Create_Campaign_When_Campaign_EndDate_Is_invalid' do

    puts(".....................Should_Not_Create_Campaign_When_Campaign_EndDate_Is_invalid.....................")
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 15
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").text).should == AppNameEditted}
    @driver.find_element(:xpath, ".//*[@id='select2-drop']/ul/li/div").click

    time = Date.today + 1
    formatedDate = time.strftime("%Y-%m-%d")

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedDate

    @driver.find_element(:name,"campaignEndDate").clear
    @driver.find_element(:name, "campaignEndDate").send_key "2010"

    financialSection
    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_CPI_Is_empty
  it 'Should_Not_Create_Campaign_When_CPI_Is_empty' do

    puts(".....................Should_Not_Create_Campaign_When_CPI_Is_empty.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys ""
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "12"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    sleep 2

    targetingAndCreativeSections

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_CPI_Is_Invalid
  it 'Should_Not_Create_Campaign_When_CPI_Is_Invalid' do

    puts(".....................Should_Not_Create_Campaign_When_CPI_Is_Invalid.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys " "
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "12"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    targetingAndCreativeSections
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_CPI_Is_NaN
  it 'Should_Not_Create_Campaign_When_CPI_Is_NaN' do

    puts(".....................Should_Not_Create_Campaign_When_CPI_Is_NaN.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "NaN"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "12"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    targetingAndCreativeSections
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  #Should_Not_Create_Campaign_When_CPI_Is_GreaterThan_DailyMaxBudget
  it 'Should_Not_Create_Campaign_When_CPI_Is_GreaterThan_DailyMaxBudget' do

    puts(".....................Should_Not_Create_Campaign_When_CPI_Is_GreaterThan_DailyMaxBudget.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "1200"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "12"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    targetingAndCreativeSections
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  # Should_Not_Create_Campaign_When_DailyMaxBudget_Is_Empty
  it 'Should_Not_Create_Campaign_When_DailyMaxBudget_Is_Empty' do

    puts(".....................Should_Not_Create_Campaign_When_DailyMaxBudget_Is_Empty.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "07"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys ""
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    targetingAndCreativeSections
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  # Should_Not_Create_Campaign_When_DailyMaxBudget_Is_Invalid
  it 'Should_Not_Create_Campaign_When_DailyMaxBudget_Is_Invalid' do

    puts(".....................Should_Not_Create_Campaign_When_DailyMaxBudget_Is_Invalid.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "07"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys " "
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    targetingAndCreativeSections
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  # Should_Not_Create_Campaign_When_DailyMaxBudget_Is_NaN
  it 'Should_Not_Create_Campaign_When_DailyMaxBudget_Is_NaN' do

    puts(".....................Should_Not_Create_Campaign_When_DailyMaxBudget_Is_NaN.....................")

    basicSettingsSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "07"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "NaN"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    
    targetingAndCreativeSections
    
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  # Should_Not_Create_Campaign_When_DailyMaxBudget_Is_GreaterThan_OverAllBudget
  it 'Should_Not_Create_Campaign_When_DailyMaxBudget_Is_GreaterThan_OverAllBudget' do

    puts(".....................Should_Not_Create_Campaign_When_DailyMaxBudget_Is_GreaterThan_OverAllBudget.....................")

    basicSettingsSection

    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "07"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "2133"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    targetingAndCreativeSections
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end

  # Should_Not_Create_Campaign_When_OverAllBudget_Is_Empty
  it 'Should_Not_Create_Campaign_When_OverAllBudget_Is_Empty' do

  puts(".....................Should_Not_Create_Campaign_When_OverAllBudget_Is_Empty.....................")

  basicSettingsSection

  sleep 10
  @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
  sleep 2
  @driver.find_element(:name, "campaignBid").clear
  @driver.find_element(:name, "campaignBid").send_keys "07"
  @driver.find_element(:id, "dailymax").clear
  @driver.find_element(:id, "dailymax").send_keys "21"
  @driver.find_element(:name, "overallMax").clear
  @driver.find_element(:name, "overallMax").send_keys ""
  targetingAndCreativeSections
  @driver.find_element(:css, "button.greenLarge.submitForm").click
  sleep 20
  (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

end

# Should_Not_Create_Campaign_When_OverAllBudget_Is_Invalid
it 'Should_Not_Create_Campaign_When_OverAllBudget_Is_Invalid' do

  puts(".....................Should_Not_Create_Campaign_When_OverAllBudget_Is_Invalid.....................")

  basicSettingsSection

  sleep 10
  @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
  sleep 2
  @driver.find_element(:name, "campaignBid").clear
  @driver.find_element(:name, "campaignBid").send_keys "07"
  @driver.find_element(:id, "dailymax").clear
  @driver.find_element(:id, "dailymax").send_keys "21"
  @driver.find_element(:name, "overallMax").clear
  @driver.find_element(:name, "overallMax").send_keys "  "
  targetingAndCreativeSections
  @driver.find_element(:css, "button.greenLarge.submitForm").click
  sleep 20
  (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

end

# Should_Not_Create_Campaign_When_OverAllBudget_Is_NaN
it 'Should_Not_Create_Campaign_When_OverAllBudget_Is_NaN' do

  puts(".....................Should_Not_Create_Campaign_When_OverAllBudget_Is_NaN.....................")

  basicSettingsSection

  @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
  sleep 2
  @driver.find_element(:name, "campaignBid").clear
  @driver.find_element(:name, "campaignBid").send_keys "07"
  @driver.find_element(:id, "dailymax").clear
  @driver.find_element(:id, "dailymax").send_keys "21"
  @driver.find_element(:name, "overallMax").clear
  @driver.find_element(:name, "overallMax").send_keys "NaN"

  targetingAndCreativeSections

  @driver.find_element(:css, "button.greenLarge.submitForm").click
  sleep 20
  (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

end

# Should_Not_Create_Campaign_When_Creatives_Are_Empty
  it 'Should_Not_Create_Campaign_When_Creatives_Are_Empty' do

    puts(".....................Should_Not_Create_Campaign_When_Creatives_Are_Empty.....................")

    basicSettingsSection
    financialSection

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen13']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key '2.1'
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == '2.1' }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[4]").click
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20
    (@driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/div[1]").text).should == GeneralErrorMessage

  end


  #Should_Create_Campaign_When_All_The_Informations_Are_valid
  it "Should_Create_Campaign_When_All_The_Informations_Are_valid" do

    puts(".....................Should_Create_Campaign_When_All_The_Informations_Are_valid.....................")

    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 10
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key "Applications"
    sleep 2
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == "Applications" }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click

    time = Date.today + 1
    formatedDate = time.strftime("%Y-%m-%d")

    @driver.find_element(:name,"campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedDate

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "1"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "12"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "123"
    sleep 2

    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen13']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key "2.1"

    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == "2.1" }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click

    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[4]").click
    @driver.find_element(:name, "ui_ad_type_2").click
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20

    @driver.find_element(:xpath, "//*[@id='filterApps']").click
    @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys CampaignName, :enter
    sleep 5

    (@driver.find_element(:link, CampaignName).text).should == CampaignName

  end
  
  #Should_Be_Able_To_Edit_BasiSettings_Section
  it "Should_Be_Able_To_Edit_BasiSettings_Section " do
  
    puts(".....................Should_Be_Able_To_Edit_BasiSettings_Section.....................")
   
    @driver.find_element(:link, CampaignName).click
    sleep 15
    !60.times{ break if (element_present?(:id, "campaignName") rescue false); sleep 1 }
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Advertiser Campaign is editted"
    
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20

    @driver.find_element(:xpath, "//*[@id='filterApps']").click
    @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys CampaignName, :enter
    sleep 5

    @driver.find_element(:link, CampaignName).click
    sleep 15
    
    (@driver.find_element(:id, "appDescription").text).should == "Advertiser Campaign is editted"
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 20
    
    @driver.find_element(:xpath, "//*[@id='filterApps']").click
    @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys CampaignName, :enter
    sleep 5

    (@driver.find_element(:link, CampaignName).text).should == CampaignName
    
  end
  
  
  #Should_Be_Able_To_Edit_Financial_Section
  it "Should_Be_Able_To_Edit_Financial_Section " do
  
    puts(".....................Should_Be_Able_To_Edit_Financial_Section.....................")
   
    @driver.find_element(:link, CampaignName).click
    sleep 15
    
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, 'campaignBid').clear
    @driver.find_element(:name, 'campaignBid').send_keys '21'
    @driver.find_element(:id, 'dailymax').clear
    @driver.find_element(:id, 'dailymax').send_keys '33'
    @driver.find_element(:name, 'overallMax').clear
    @driver.find_element(:name, 'overallMax').send_keys '1921'
    sleep 2
    
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20

    @driver.find_element(:xpath, "//*[@id='filterApps']").click
    @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys CampaignName, :enter
    sleep 5

    @driver.find_element(:link, CampaignName).click
    sleep 15
    
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 10
     
    (@driver.find_element(:name, 'campaignBid').text).should == "21"
    (@driver.find_element(:id, 'dailymax').text).should == "33"
    (@driver.find_element(:name, 'overallMax').text).should == "1921"
    
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 20
    
    @driver.find_element(:xpath, "//*[@id='filterApps']").click
    @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys CampaignName, :enter
    sleep 5

    (@driver.find_element(:link, CampaignName).text).should == CampaignName
    
  end
  
  #Should_Be_Able_To_Edit_Targetting_Section
  it "Should_Be_Able_To_Edit_Targetting_Section " do
  
    puts(".....................Should_Be_Able_To_Edit_Targetting_Section.....................")
   
    @driver.find_element(:link, CampaignName).click
    sleep 15
    
    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen13']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key '3.0'
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == '3.0' }
    
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen15']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key '4.3'
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == '4.3' }
    
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 20

    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    
    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 20
    
    @driver.find_element(:xpath, "//*[@id='filterApps']").click
    @driver.find_element(:xpath, "//*[@id='filterApps']").send_keys CampaignName, :enter
    sleep 5

    (@driver.find_element(:link, CampaignName).text).should == CampaignName
    
  end
  
  
  it "test_edit_advertisercamp" do

    puts("Edit camp")


    sleep 10
    @driver.find_element(:link, CampaignName).click
    sleep 20
    !60.times{ break if (element_present?(:id, "campaignName") rescue false); sleep 1 }
    @driver.find_element(:id, "campaignName").clear
    CampNameEditted = CampaignName.concat(" Editted")

    @driver.find_element(:id, "campaignName").send_keys CampNameEditted
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Editting automation testing of advertiser campaign"
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, "campaignBid").clear
    @driver.find_element(:name, "campaignBid").send_keys "4"
    @driver.find_element(:id, "dailymax").clear
    @driver.find_element(:id, "dailymax").send_keys "45"
    @driver.find_element(:name, "overallMax").clear
    @driver.find_element(:name, "overallMax").send_keys "456"
    sleep 2

    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen13']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key "3.1"

    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == "3.1" }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click

    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 10

    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys CampNameEditted, :enter
    !60.times{ break if (element_present?(:link, CampNameEditted) rescue false); sleep 1 }
    (@driver.find_element(:link, CampNameEditted).text).should == CampNameEditted
    @driver.find_element(:link, CampNameEditted).click
    sleep 15

    verify { (@driver.find_element(:id, "campaignName").text).should == CampNameEditted }
    verify { (@driver.find_element(:id, "appDescription").text).should == "Editting automation testing of advertiser campaign "}

    verify { (@driver.find_element(:name, "campaignBid").text).should == "4" }
    verify { (@driver.find_element(:id, "dailymax").text).should == "45" }
    verify { (@driver.find_element(:name, "overallMax").text).should == "456" }


    @driver.find_element(:xpath, "//*[@id='pgWrap']/div[3]/form/div[7]/button[1]").click
    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    sleep 15
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys CampNameEditted,:enter

    !60.times{ break if (element_present?(:link, CampNameEditted) rescue false); sleep 1 }
    (@driver.find_element(:link, CampNameEditted).text).should == CampNameEditted


  end
  
  def basicSettingsSection

    @driver.get(@base_url + "/b/advertiser_campaign.html")
    sleep 10
    @driver.find_element(:id, "campaignName").clear
    @driver.find_element(:id, "campaignName").send_keys CampaignName
    @driver.find_element(:id, "appDescription").clear
    @driver.find_element(:id, "appDescription").send_keys "Doing automation testing of advertiser campaign"
    sleep 20
    @driver.find_element(:xpath, "//*[@id='s2id_autogen1']/a/span[1]").click
    sleep 2
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key AppNameEditted
    sleep 2
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == AppNameEditted }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click

    time = Date.today + 1
    formatedDate = time.strftime("%Y-%m-%d")

    @driver.find_element(:name, "campaignStartDate").clear
    @driver.find_element(:name, "campaignStartDate").send_key formatedDate

    sleep 10

  end
def financialSection

    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[2]").click
    sleep 2
    @driver.find_element(:name, 'campaignBid').clear
    @driver.find_element(:name, 'campaignBid').send_keys '1'
    @driver.find_element(:id, 'dailymax').clear
    @driver.find_element(:id, 'dailymax').send_keys '12'
    @driver.find_element(:name, 'overallMax').clear
    @driver.find_element(:name, 'overallMax').send_keys '123'
    sleep 2
end

  def targetingAndCreativeSections

    sleep 10
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[3]").click
    @driver.find_element(:xpath ,"//*[@id='s2id_autogen13']/a").click
    @driver.find_element(:xpath, "//*[@id='select2-drop']/div/input").send_key '2.1'
    verify { (@driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").text).should == '2.1' }
    @driver.find_element(:xpath, "//*[@id='select2-drop']/ul/li[1]/div").click
    @driver.find_element(:xpath, "//div[@id='undefined-sticky-wrapper']/div/div[4]").click
    @driver.find_element(:name, 'ui_ad_type_2').click

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
