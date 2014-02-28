require 'nokogiri'
require 'open-uri'
require 'spreadsheet'
require 'rspec'

  @xmlarr = []
  @xcelarr = []
  @coutryTargeting=[]
  @devices = []
  @motiveCid= ""
  @motiveofferid=""
  
  book = Spreadsheet.open('/Users/sebibbaby/Google Drive/QA/SQL Scripts/Exports/Motive_Camp_Status.xls')
  doc = (Nokogiri::XML(open("http://motivefeed.com/affiliate/campaigns_v2?api_key=LstKht1GD0&affiliate_id=64104.xml"))).to_s
  doc1 = Nokogiri::XML(open("http://motivefeed.com/affiliate/campaigns_v2?api_key=LstKht1GD0&affiliate_id=64104.xml"))
  sheet1 = book.worksheet('Part 1') # can use an index or worksheet name
  dateTime = ((Time.new).strftime("%Y-%m-%d %H.%M")).to_s
  
  sheet1[0,8] = "Motive Status"
  sheet1[0,11] = "Motive Country Status"
  sheet1[0,14] = "Motive Platform Status"
  sheet1[0,16] = "Motive Campaign Id"
  sheet1[0,17] = "Motive Offer Id"
 
   
  sheet1.each 1 do |row|
  break if row[0].nil? # if first cell empty
  @xcelarr<< row[1].to_s # looks like it calls "to_s" on each cell's Value
    
  if doc.include? row[1].to_s
    
    row[10] = @xmlarr.pop
    row[8] = "Active"
    
     if(row[8] == row[6])
        row[9] = "Match"
       
      else
        row[9] = "MisMatch"
      end    
      else
        row[10] = @xmlarr.pop
        row[8] = "Paused"
      
      if(row[8] == row[6])
         row[9] = "Match"
       
          else if(row[6] == "Expired")
            row[9] = "Match"
      else
        row[9] = "Mismatch"
      end    
    end
  end
end


  doc1.search('//campaign').each do |xml|
  trakingLink   = xml.at('tracking_link').text
  @xmlarr<<trakingLink
  @xcelarr.each do |values|
    
    if trakingLink.include? values  
        xml.xpath("allowed_countries/allowed_country").each do |t| 
        @coutryTargeting<<t.text.downcase
    end
      xml.xpath("allowed_devices/allowed_device").each do |d|
      @devices<<d.text
    end
      xml.xpath("campaign_id").each do |cid|
      @motiveCid = cid.text
    end
      xml.xpath("offer_id").each do |oid|
      @motiveofferid = oid.text
    end
 
 
  sheet1.each 1 do |row|
  break if row[0].nil?
  
    if(row[1].to_s == values.to_s)
      
      row[16] = @motiveCid.to_s
      row[17] = @motiveofferid
      row[11]=@coutryTargeting.join(",")     
        if((CompareValue(row[4].to_s,row[11].to_s,"country")) == 0)
            row[12] = "Match"
        else 
            row[12] = "Mismatch"     
      end
    
      row[14]=@devices.join(",")
      
        if((CompareValue(row[5].to_s,row[14].to_s,"device")) == 0)
            row[15] = "Match"
        else
            row[15] = "Mismatch" 
        end
      end
    end
    @coutryTargeting.clear
    @devices.clear
    @motiveCid = ""
    @motiveofferid = ""
  end 
end 

  def CompareValue(val1,val2,from)
    
    if(from == "country")
        val1.casecmp val2
    else
      if(val2.include? val1)
    end
      return 0
    end
  end     
end

book.write "/Users/sebibbaby/Google Drive/QA/Automation Test Results/Partner Campaign Analysis/Motive/ #{dateTime}.xls"
