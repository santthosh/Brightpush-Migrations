require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/ua_android_migration.rb'

describe "UA_Android_Migration" do
  it "should perform migrations of Android device tokens from Urban Airship to our system" do
    UA_Android_Migration.method_defined?(:perform)
  end
end