require 'resque-status'
import 'simpledb.rb'
import 'ua_api.rb'

# Migrates the apids from Urban Airship to newsstand for Android applications
module UA_Android_Migration 
    include Resque::Plugins::Status
  @queue = :migrations
  
  # Process apids list
  def self.process_apids(domain,apids)
    apids.each do |apid|
     	item_name = apid["apid"]
     	
     	# If apid doesn't exist add it
     	unless domain.items[item_name].nil?
     	  item = { :last_registration => Time.now.iso8601, :c2dm_registration_id => apid["c2dm_registration_id"],:active => apid["active"], :alias => apid["alias"] }
     	  domain.items.create item_name,item
     	else 
     	  # Update it if necessary
     	  item = domain.items[item_name]
     	  if !apid["active"]
     	    item.attributes.replace(:active => 0, :if => { :active => 1 })
     	  end
     	end
     	print  "."
    end
  end

  # Execute the job
  def self.perform(identifier,key,master_secret)
    if identifier.nil? || key.nil? || master_secret.nil?
      raise 'Invalid identifier, key or master_secret'
    end 
    
    # Get the domain, if its not found create one
    domain = SimpleDB.get_domain(identifier)
  
    unless domain.nil?
      url = UA_API.url_for_android_device_token_list
      
      # Get UA apid list and process them one page at a time
      until url.nil? do
        puts "#{url}"
        response = UA_API.get_next_page(url,key,master_secret)
        url = response["next_page"]
        
        UA_Android_Migration.process_apids(domain,response["apids"])
      end
      puts  "finished migrations"
    end
  end
  
end