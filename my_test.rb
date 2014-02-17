require 'rubygems'
gem "test-unit"
require 'test/unit'
require 'selenium-webdriver'


class IndexPageChecking < Test::Unit::TestCase

  def setup
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    caps.version = "5"
    caps.platform = :XP
    caps[:name] = "Testing Selenium  3"



    @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://btsauce:3d284ce4-ce68-4128-acc2-da28928ff141@ondemand.saucelabs.com:80/wd/hub",
        :desired_capabilities => caps)

    #@driver.manage().window().maximize()
    #@base_url = "http://uat-portal.blutrumpet.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end

  def test_index_page_checking
    @driver.navigate.to "http://uat-portal.blutrumpet.com/b/site/index.html"
    verify { assert_equal "LOG IN", @driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[4]/a").text }
    verify { assert_equal "SIGN UP", @driver.find_element(:xpath, "//*[@id='topBar']/div/div[1]/ul[2]/li[3]/a").text }
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
  rescue Test::Unit::AssertionFailedError => ex
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
