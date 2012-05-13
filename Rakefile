require 'resque/tasks'
require 'resque-status'
require 'sinatra'
import 'simpledb.rb'
import 'ua_android_migration.rb'
import 'ua_api.rb'
import 'ua_ios_migration.rb'

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque-status'
    
    Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
    
    rails_env = ENV['RAILS_ENV'] || 'development'

    if rails_env == 'production'
      $redis = Redis.new(:host => 'redis.brightpush.in')
    elsif rails_env == 'staging'
      $redis = Redis.new(:host => 'redis.brightpushbeta.in')
    elsuf rails_env == 'test'
      $redis = Redis.new(:host => 'redis.brightpushalpha.in')
    else 
      $redis = 'localhost:6379'
    end
    
    # Setup the shared redis server
    Resque.redis = $redis
  end
end