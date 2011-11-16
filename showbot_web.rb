# showbot_web.rb
# The web front-end for showbot

# Gems
require 'bundler/setup'
require 'sinatra' unless defined?(Sinatra)
require "sinatra/reloader" if development?

require File.join(File.dirname(__FILE__), 'environment')


SHOWS_JSON = File.expand_path(File.join(File.dirname(__FILE__), "public", "shows.json"))

configure do
  set :public, "#{File.dirname(__FILE__)}/public"
  set :views, "#{File.dirname(__FILE__)}/views"
  set :shows, Shows.new(SHOWS_JSON)
end

# =================
# Pages
# =================

get '/' do
  @title = "Title Suggestions in the last 24 hours"
  @suggestions = Suggestion.recent.all(:order => [:created_at.desc])
  haml :index
end

get '/links' do
  @title = "Suggested Links in the last 24 hours"
  @links = Link.all(:order => [:created_at.desc])
  haml :links
end

get '/all' do
  @title = "All Title Suggestions"
  @suggestions = Suggestion.all(:order => [:created_at.desc])
  haml :index
end

# ===========
# CSS
# ===========
get '/showbot.css' do
  scss :showbot
end

# ===========
# Helpers
# ===========

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def external_link(link)
    /^http/.match(link) ? link : "http://#{link}"
  end
end
