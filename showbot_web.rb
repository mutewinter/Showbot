# showbot_web.rb
# The web front-end for showbot

# Gems
require 'bundler/setup'
require 'sinatra' unless defined?(Sinatra)
require "sinatra/reloader" if development?

require File.join(File.dirname(__FILE__), 'environment')


configure do
  set :public, "#{File.dirname(__FILE__)}/public"
  set :views, "#{File.dirname(__FILE__)}/views"
end

# =================
# Pages
# =================

get '/' do
  @suggestions = Suggestion.recent
  haml :index
end

get '/popular' do
  @suggestions = Suggestion.recent.sort_by { |suggestion| -suggestion.votes.count }
  haml :index
end

get '/suggestion/:id/vote-up' do
  Suggestion.get(params[:id]).vote_up(@env['REMOTE_ADDR'])
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
end
 
