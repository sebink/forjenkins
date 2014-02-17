require 'json'
require 'selenium-webdriver'
require "rspec"
include RSpec::Expectations

describe 'Login' do

  before(:all) do
caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps['platform'] = "Windows 8.1"
    caps['version'] = "26"
    caps[:name] = "Mobile Web Site"

    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://btsauce:3d284ce4-ce68-4128-acc2-da28928ff141@ondemand.saucelabs.com:80/wd/hub",
        :desired_capabilities => caps)
        
   @base_url = "http://uat-portal.blutrumpet.com/"
   @accept_next_alert = true
   @driver.manage.timeouts.implicit_wait = 30
   @verification_errors = []

    MW_Name = Array.new(10){rand(10).to_s(10)}.join
    MWURLBase = "https://play.google.com/store/apps/details?id=com"
    MW_URL = (MWURLBase.concat(MW_Name).concat("com")).to_str()


  end

  after(:all) do

    #@verification_errors.should == []
    #@driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/img").click
    #@driver.find_element(:xpath,"//*[@id='pgWrap']/div[1]/div[2]/div/div[5]").click
    #sleep 5

    #verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text).should == "SIGN UP" }
    #verify { (@driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[4]/a").text).should == "LOG IN" }
    @driver.quit

  end

  #login into the system before doing anything.
  it "test_Init_login" do

    puts('.....................Login for mobile Website.....................')

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
    verify { (@driver.find_element(:css, 'button.drkGrey').text).should == "FILTER" }
    verify { (@driver.find_element(:css, 'div.chartHdr').text).should == "Application Earn" }
    verify { (@driver.find_element(:css, 'div.chartCell.right > div.chartHdr').text).should == "Campaign Spend" }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[5]/div").text).should == "Campaign Installs" }
    verify { (@driver.find_element(:xpath, "//div[@id='pgWrap']/div[3]/div[4]/div").text).should == "Campaign Impressions" }

  end


  it "test_CreateMobileWebsite" do

    puts('.....................Create mobile websites.....................')
    @driver.get(@base_url + '/b/mobile_website.html')
    sleep 10
    (@driver.find_element(:css, "div.left.label").text).should == "Add Mobile Website"

    @driver.find_element(:id, "mw_name").clear
    @driver.find_element(:id, "mw_name").send_keys MW_Name
    @driver.find_element(:id, "mw_url").clear
    @driver.find_element(:id, "mw_url").send_keys MW_URL
    @driver.find_element(:id, "mw_category").click


    #Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath, "//*[@id='mw_category']")).select_by(:text, "Book")
    #@driver.find_element(:css, "option[value=\"5\"]").click

    @driver.find_element(:xpath ,"//*[@id='mw_category']").click
    @driver.find_element(:xpath ,"//*[@id='mw_category']").find_elements( :tag_name => "option" ).find do |option|
      option.text == "Book"
      end.click


    Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath, "//form[@id='pageForm']/div/div[3]/div/table/tbody/tr/td[2]/select")).select_by(:text, "iOS")
    @driver.find_element(:css, "option[value=\"Android\"]").click
    sleep 5
    @driver.find_element(:css, "button.greenLarge.submitForm").click

    sleep 15
    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys MW_Name, :enter
    sleep 3
    !60.times{ break if (element_present?(:link, MW_Name) rescue false); sleep 1 }
    (@driver.find_element(:link, MW_Name).text).should == MW_Name

  end

  it "test_edit_MobileWebsite" do

    puts('.....................Edit mobile websites.....................')
    sleep 3
    @driver.find_element(:link, MW_Name).click
    sleep 15
    !60.times{ break if (element_present?(:id, "mw_name") rescue false); sleep 1 }
    @driver.find_element(:id, "mw_name").clear
    MWNameEditted = MW_Name.concat(" Editted")

    @driver.find_element(:id, "mw_name").send_keys MWNameEditted

    @driver.find_element(:xpath ,"//*[@id='mw_category']").click
    @driver.find_element(:xpath ,"//*[@id='mw_category']").find_elements( :tag_name => "option" ).find do |option|
      option.text == "Sports"
    end.click

    sleep 3
    @driver.find_element(:css, "button.greenLarge.submitForm").click
    sleep 10

    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys MWNameEditted, :enter
    !60.times{ break if (element_present?(:link, MWNameEditted) rescue false); sleep 1 }
    (@driver.find_element(:link, MWNameEditted).text).should == MWNameEditted
    @driver.find_element(:link, MWNameEditted).click
    sleep 5


    verify { (@driver.find_element(:xpath, "//*[@id='mw_GUIDRow']/td[1]").text).should == "Your AppWall Link" }
    @driver.find_element(:xpath, "//*[@id='pageForm']/div/div[4]/button[1]").click
    !60.times{ break if (element_present?(:id, "filterApps") rescue false); sleep 1 }
    sleep 15
    @driver.find_element(:id, "filterApps").click
    @driver.find_element(:id, "filterApps").send_keys MWNameEditted,:enter

    !60.times{ break if (element_present?(:link, MWNameEditted) rescue false); sleep 1 }
    (@driver.find_element(:link, MWNameEditted).text).should == MWNameEditted


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
