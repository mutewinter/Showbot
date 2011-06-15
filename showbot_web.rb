# showbot_web.rb
# The web front-end for showbot


# =================
# Dependencies
# =================

# Gems
require 'sinatra'
require 'haml'

# Add the script directory as possible directory for files
dir = File.dirname(File.realdirpath(__FILE__))
$: << dir

# Showbot
require 'lib/showbot'

# =================
# Configuration
# =================

set :public, File.dirname(__FILE__) + '/public'

configure do
  @bot_thread = Thread.new do
    while true
      @@bot ||= Showbot::Bot.new("showbot")
      #@@bot.start
      @@bot.suggestion_test

      puts "Bot stopped, reconning in 10 seconds"
      sleep 10
    end
  end
end

# =================
# Pages
# =================

get '/' do
  @suggestions = @@bot.suggestions
  haml :index
end

# ===========
# CSS
# ===========
get '/showbot.css' do
  scss :showbot
end

# ===========
# Javascript
# ===========
get '/js/*.js' do |file|

end
