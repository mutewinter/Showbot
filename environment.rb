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
  # Make sure only available locales are used. This will be the default in the
  # future but we need this to silence a deprecation warning
  I18n.config.enforce_available_locales = true
  I18n.config.default_locale = ENV['SHOWBOT_LOCALE']
  I18n.config.locale = I18n.config.default_locale

  # load models
  Dir.glob("#{File.dirname(__FILE__)}/lib/models/*.rb").sort.each { |lib| require lib }

  def t(*args)
    # Just a simple alias
    I18n.t(*args)
  end

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
