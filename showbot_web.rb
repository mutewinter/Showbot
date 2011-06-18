# showbot_web.rb
# The web front-end for showbot


# =================
# Dependencies
# =================

# Gems
require 'sinatra'
require 'haml'
require 'sass'
require "sinatra/reloader" if development?

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

      if development?
        @@bot.suggestion_test
      else
        @@bot.start
      end

      puts "Bot stopped, reconning in 10 seconds"
      sleep 60
    end
  end
end

# =================
# Pages
# =================

get '/' do
  @suggestions = []
  if defined? @@bot
    @suggestions = @@bot.suggestions
    yesterday = Time.now - (60 * 60 * 24)
    # Default to showing suggestions in last 24 hours
    @suggestions.reject! {|s| s.time < yesterday}
    @suggestions.compact! if @suggestions
  end
  haml :index
end


get '/fix_nick' do
  if @@bot.bot.nick != "showbot"
    @@bot.bot.nick = "showbot"
    "Fixed, hopefully."
  else
    "It's Fine."
  end
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
