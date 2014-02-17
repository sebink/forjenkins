require 'json'
require 'selenium-webdriver'
require 'rspec'
include RSpec::Expectations

describe 'ExecutingAll' do

  puts(" Satrted Test Landing Page Check" )
  require './LandingPageChecking.rb'
  puts(" Satrted Login" )
  require './Login.rb'
  puts(" Satrted MW Check" )
  require './MobileWebsite.rb'
  puts(" Satrted Application And Campaign" )
  require './AdvertiserCampaign.rb'

end
