require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'haml'
require 'sass'
require 'i18n'

require 'sinatra' unless defined?(Sinatra)

LIVE_URL = ENV['DATA_JSON_URL']

configure do
  Dir[File.join(Dir.pwd, 'locales', '*.yml')].each {|file| I18n.load_path << file }
  I18n.default_locale = ENV['SHOWBOT_LOCALE']
  
  # load models
  Dir.glob("#{File.dirname(__FILE__)}/lib/models/*.rb") { |lib| require lib }
end

configure(:production, :development) do
  DataMapper::Logger.new(STDOUT, :debug) if settings.development?

  current_directory = File.expand_path(File.dirname(__FILE__))
  sqlite_file = File.join(current_directory, 'db', "#{Sinatra::Base.environment}.db")
  DataMapper.setup(:default, (ENV["SHOWBOT_DATABASE_URL"] ||
                              "sqlite3:///#{sqlite_file}"))
  DataMapper.finalize
end

configure :test do
  puts 'Test configuration in use'
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
  DataMapper.finalize
end
