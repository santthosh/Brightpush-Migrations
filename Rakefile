require 'resque/tasks'
require 'sinatra'
import 'lib/simpledb.rb'
import 'lib/ua_android_migration.rb'
import 'lib/ua_api.rb'
import 'lib/ua_ios_migration.rb'

task :default => :help

namespace :resque do
  task :setup do
    require 'resque'
    
    rack_env = ENV['RACK_ENV'] || 'development'

    if rack_env == 'production'
      $redis = Redis.new(:host => 'redis.brightpush.in')
    elsif rack_env == 'staging'
      $redis = Redis.new(:host => 'redis.brightpushbeta.in')
    elsuf rack_env == 'development'
      $redis = Redis.new(:host => 'redis.brightpushalpha.in:6379')
    else 
      $redis = 'localhost:6379'
    end
    
    # Setup the shared redis server
    Resque.redis = $redis
  end
end

desc "Run specs"
task :spec do
  require 'rspec/core/rake_task'
  
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end

desc "Run IRB console with app environment"
task :console do
  puts "Loading development console..."
  system("irb -r ./config/boot.rb")
end

desc "Show help menu"
task :help do
  puts "Available rake tasks: "
  puts "rake console - Run a IRB console with all enviroment loaded"
  puts "rake spec - Run specs and calculate coverage"
end