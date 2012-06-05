require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/ua_ios_migration.rb'

describe "UA_iOS_Migration" do
  it "should perform migrations of iOS device tokens from Urban Airship to our system" do
    UA_iOS_Migration.method_defined?(:perform)
  end
end