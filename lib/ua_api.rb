require 'net/http'  
require 'uri'
require 'json'

module JSON
  def self.parse_nil(json)
    JSON.parse(json) if json && json.length >= 2
  end
end

# Helper class to facilitate migration from Urban Airship
module UA_API
  
  def self.url_for_ios_device_token_list
    return "https://go.urbanairship.com/api/device_tokens/";
  end
  
  def self.url_for_android_device_token_list
    return "https://go.urbanairship.com/api/apids/?limit=5000";
  end
  
  # Get the JSON response from Urban Airship
  def self.get_next_page(url,key,master_secret)
    uri = URI.parse(url)
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(key, master_secret)
    response = http.request(request)
    
    return response.body && response.body.length >= 2 ? JSON.parse(response.body) : nil
  end
end