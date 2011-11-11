require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'haml'
require 'sass'

require 'sinatra' unless defined?(Sinatra)

LIVE_URL = 'http://5by5.tv/live/data.json'

configure do
  # load models
  Dir.glob("#{File.dirname(__FILE__)}/lib/models/*.rb") { |lib| require lib }

  DataMapper.setup(:default, (ENV["SHOWBOT_DATABASE_URL"] || "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db"))
  DataMapper.finalize
end
