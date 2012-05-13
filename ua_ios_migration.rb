require 'resque-status'
import 'simpledb.rb'
import 'ua_api.rb'

# Migrates the device_tokens from Urban Airship to newsstand for iOS applications
module UA_iOS_Migration 
    include Resque::Plugins::Status
  @queue = :migrations
  
  # Process device token list
  def self.process_device_tokens(domain,device_tokens)
    device_tokens.each do |device_token|
     	item_name = device_token["device_token"]
     	
     	# If token doesn't exist add it
     	unless domain.items[item_name].nil?
     	  item = { :last_registration => Time.now.iso8601, :active => device_token["active"], :alias => device_token["alias"] }
     	  domain.items.create item_name,item
     	else 
     	  # Update it if necessary
     	  item = domain.items[item_name]
     	  if !device_token["active"]
     	    item.attributes.replace(:active => 0, :if => { :active => 1 })
     	  end
     	end
     	
     	print "."
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
      url = UA_API.url_for_ios_device_token_list
      
      # Get UA device_token list and process them one page at a time
      until url.nil? do
        puts "#{url}"
        response = UA_API.get_next_page(url,key,master_secret)
        url = response["next_page"]
        
        UA_iOS_Migration.process_device_tokens(domain,response["device_tokens"])
      end
      puts  "finished migrations. total:#{response["device_tokens_count"]} active:#{response["active_device_tokens_count"]}"
    end
  end
  
end