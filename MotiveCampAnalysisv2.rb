require 'nokogiri'
require 'open-uri'
require 'spreadsheet'
require 'rspec'


dateTime = ((Time.new).strftime("%Y-%m-%d %H.%M")).to_s
FileUtils.cp("/Users/sebibbaby/Google Drive/QA/SQL Scripts/Exports/Motive_Camp_Status.xls", File.dirname(__FILE__))
book = Spreadsheet.open('/Users/sebibbaby/Google Drive/QA/SQL Scripts/Exports/Motive_Camp_Status.xls')#/Users/sebibbaby/Google Drive/QA/SQL Scripts
@doc = Nokogiri::XML(open("http://motivefeed.com/affiliate/campaigns_v2?api_key=LstKht1GD0&affiliate_id=64104.xml"))
modifiedFile = "/Users/sebibbaby/Google Drive/QA/Automation Test Results/Partner Campaign Analysis/Motive/#{dateTime}.xls"
@sheet1 = book.worksheet(0)
@xmlString = @doc.inspect()
@xcelarr =[]
@coutryTargeting=[]
@devices = []
@motiveCid= ""
@motiveofferid=""

@sheet1[0,9] = "Motive Status"
@sheet1[0,14] = "Motive Country Status"
@sheet1[0,12] = "Motive Platform Status"

#@sheet1[0,16] = "Motive Campaign Id"
#@sheet1[0,17] = "Motive Offer Id"


#str1 = '(235938:157117) Check: Pay Bills & Credit Card'
#puts str1[8..13]
def exactcid 
  @sheet1.each_with_index 0 do |row,ind|
  break if row[0].nil?
  if row[6]=="Active" 
    str = row[3].to_s[8..13]
    @xcelarr<< str 
    row[8]=str 
    #puts str
     getvaluesOfActiveOnes(str,ind)
     
  end
  if (row[6]=="Paused" || row[6]=="Expired")
  @xcelarr<<""
  getvaluesOfActiveOnes(row[1],ind)
  end
 end
end


def getvaluesOfActiveOnes(mcid,ind)
 puts "count"+@xmlString.scan(mcid).count.to_s+ " "+mcid
 if @xmlString.scan(mcid).count == 0
   @sheet1[ind,9] = "Paused"
   #puts "pause" + mcid.to_s
   return
 end
 
  @doc.xpath('//campaign').each do |xml|
     mCampId   = xml.at('campaign_id').text 
      if(mcid == mCampId)
        
            xml.xpath("allowed_countries/allowed_country").each do |t| 
            @coutryTargeting<<t.text.downcase
        end
          xml.xpath("allowed_devices/allowed_device").each do |d|
          @devices<<d.text
        end
          xml.xpath("offer_id").each do |oid|
          @motiveofferid=oid.text
        end 
   
      @sheet1[ind,9] = "Active"
      @sheet1[ind,15] = @motiveofferid
      @sheet1[ind,13]=@coutryTargeting.join(",")  
      @sheet1[ind,11]=@devices.join(",")     
 

    @coutryTargeting.clear
    @devices.clear
    @motiveCname = ""
    @motiveCname = ""
    @motiveCname= ""
  end
 end  
 end 
 

def camparingvalues
  
  @sheet1.each_with_index 1 do |row,ind|
  break if row[0].nil?
  
  if(row[9] == row[6])
         row[10] = "Match"
       
   else
     row[10] = "MisMatch"
   end    
  if (row[6] == "Expired")
    row[10] = "Match"
  end
  conutryvalue = row[4].to_s.split(",")
  #if((CompareValue(row[4].to_s,row[13].to_s,"country")) == 0)
 if((comp(row[4].to_s,row[13].to_s,conutryvalue)) == 1)
        row[14] = "Match"
      else 
        row[14] = "Mismatch"
        if(row[13].nil?)
          row[14]=""
          end     
    end
      devicevalue = row[5].to_s.split(",")
        row11= row[11].to_s.downcase
        row5 = row[5].to_s.downcase
        
        if(row11.include? row5)
        row[12] = "Match"
      else
        row[12] = "Mismatch" 
      end
      if(row[11].nil?)
          row[12]=""
          end  
  end
end
def CompareValue(val1,val2,from)
  if(from == "country")
    val1.casecmp val2
  else
    if(val2.include? val1)
     val1.casecmp val2
    end
    return 0
  end
 end
 
 def comp(str1,str2,str3)
   str3.each do |s|
    if(str2.include? s )&& (str1.length == str2.length)
      return 1
    #puts 1 
    else
      return 0
    #puts 0
   end
  end
end
 #book.write '912132233232.xls' 
exactcid
camparingvalues
book.write modifiedFile
File.delete(File.dirname(__FILE__)+"/Motive_Camp_Status.xls")
FileUtils.cp(modifiedFile, dest_folder)