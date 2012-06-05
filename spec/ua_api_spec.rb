require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/ua_api.rb'

describe "UA_API" do
  it "should provide url for iOS device tokens list" do
    UA_Android_Migration.method_defined?(:url_for_ios_device_token_list)
  end
  
  it "should provide url for Android device tokens list" do
    UA_Android_Migration.method_defined?(:url_for_android_device_token_list)
  end
  
  it "should provide pagination support" do
    UA_Android_Migration.method_defined?(:get_next_page)
  end
end