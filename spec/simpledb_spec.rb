require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/simpledb.rb'

describe "SimpleDB" do
  it "should provide functionality for getting SimpleDB domain" do
    SimpleDB.method_defined?(:get_domain)
  end
  
  it "should provide url for Android device tokens list" do
    UA_Android_Migration.method_defined?(:url_for_android_device_token_list)
  end
  
  it "should provide pagination support" do
    UA_Android_Migration.method_defined?(:get_next_page)
  end
end