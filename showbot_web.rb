# showbot_web.rb
# The web front-end for showbot

# Gems
require 'bundler/setup'
require 'coffee_script'
require 'sinatra' unless defined?(Sinatra)
require "sinatra/reloader" if development?

require 'json'

require File.join(File.dirname(__FILE__), 'environment')


SHOWS_JSON = File.expand_path(File.join(File.dirname(__FILE__), "public", "shows.json")) unless defined? SHOWS_JSON
SAMPLE_TITLES_JSON = File.expand_path("hypercritical.json")

class ShowbotWeb < Sinatra::Base
  configure do
    set :public_folder, "#{File.dirname(__FILE__)}/public"
    set :views, "#{File.dirname(__FILE__)}/views"
    set :shows, Shows.new(SHOWS_JSON)
  end

  configure(:production, :development) do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end

  # ------------------
  # Pages
  # ------------------

  # CoffeeScript
  get '/js/showbot.js' do
    coffee :'coffeescripts/showbot'
  end

  get '/' do
    @title = "Home"
    suggestion_sets = Suggestion.recent.group_by_show
    view_mode = params[:view_mode] || 'tables'
    haml :index, :locals => {suggestion_sets: suggestion_sets, :view_mode => view_mode}
  end

  get '/titles' do
    @title = "Title Suggestions in the last 24 hours"
    view_mode = params[:view_mode] || 'tables'
    suggestion_sets = Suggestion.recent.group_by_show
    if view_mode == 'hacker'
      content_type 'text/plain'
      haml :'suggestion/hacker_mode', :locals => {suggestion_sets: suggestion_sets, :view_mode => view_mode}, :layout => false
    else
      haml :'suggestion/index', :locals => {suggestion_sets: suggestion_sets, :view_mode => view_mode}
    end
  end

  get '/links' do
    @title = "Suggested Links in the last 24 hours"
    @links = Link.recent.all(:order => [:created_at.desc])
    haml :links
  end

  get '/all' do
    suggestion_sets = Suggestion.all(:order => [:created_at.desc]).group_by_show
    content_type 'text/plain'
    haml :'suggestion/hacker_mode', :locals => {suggestion_sets: suggestion_sets}, :layout => false
  end

  get '/titles/:id/vote_up' do
    content_type :json
    # Only allow XHR requests for voting
    if request.xhr?
      suggestion = Suggestion.get(params[:id])
      cluster_top = suggestion.top_of_cluster? # figure out if top before adding new vote
      suggestion.vote_up(request.ip)
      {votes: suggestion.votes.count.to_s,
        cluster_top: cluster_top,
        cluster_id: suggestion.cluster_id,
        cluster_votes: suggestion.total_for_cluster}.to_json
    else
      redirect '/'
    end
  end

  # Word cloud generation

  get '/clouds_between/:days_a/:days_b' do
    days_ago = [params[:days_a].to_i, params[:days_b].to_i].sort
    suggestion_sets = Suggestion.all(:created_at => ( (DateTime.now - days_ago[1])..(DateTime.now - days_ago[0]) ), :order => [:created_at.desc]).group_by_show
    haml :'clouds', :locals => { cloud_data: WordCount.generate_clouds(suggestion_sets) }
  end

  get '/cloud_svg/:year/:month/:day/:index' do
    the_date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    bracketed_suggestion_sets = Suggestion.all(:created_at => ( (the_date - 1)..(the_date + 2) ), :order => [:created_at.desc]).group_by_show
    suggestion_sets = bracketed_suggestion_sets.select { |set| set.suggestions[0].created_at.to_date == the_date.to_date }

    haml :'clouds_svg', :locals => { cloud_data: WordCount.generate_clouds(suggestion_sets), cloud_index: params[:index].to_i }
  end

  get '/num_clouds_on_date/:year/:month/:day' do
    content_type :json

    the_date = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    bracketed_suggestion_sets = Suggestion.all(:created_at => ( (the_date - 1)..(the_date + 2) ), :order => [:created_at.desc]).group_by_show

    { num_clouds: bracketed_suggestion_sets.select { |set| set.suggestions[0].created_at.to_date == the_date.to_date }.count }.to_json
  end

  # ------------------
  # API
  # ------------------

  # Creates a title suggestion based on a POST request with valid
  # title and user parameters.
  #
  # title   - String less than 40 characters.
  # user    - String username to use.
  # api_key - Your API key.
  #
  # Examples
  #
  #   Context: Posting a valid show title with a valid user.
  #   POST /suggestions/new
  #   params: {
  #     title: 'Omg Title',
  #     user: 'mrman',
  #     api_key: 'keyhere'
  #   }
  #
  #   Response:
  #   {
  #     suggestion: {
  #       user: 'mrman',
  #       title: 'Omg Title'
  #     }
  #   }
  #
  #   Context: Posting a show title that's too long.
  #   POST /suggestions/new
  #   params: {
  #     title: 'Super freaking long title that will make showbot cry.',
  #     user: 'badman',
  #     api_key: 'keyhere'
  #   }
  #
  #   Response:
  #   {
  #     error: 'That suggestion was too long. Showbot is sorry. Think title,
  #             not transcript.'
  #   }
  #
  #   Context: The same title suggested seconds later.
  #   POST /suggestions/new
  #   params: {
  #     title: 'Same Title',
  #     user: 'slowpoke',
  #     api_key: 'keyhere'
  #   }
  #
  #   Response:
  #   {
  #     error: 'Darn, fastman beat you to "Same Title".'
  #   }
  #
  # Returns a JSON response with the original suggestion and an error
  # message if one was generated.
  post '/suggestions/new' do
    content_type :json

    api_key = params[:api_key]
    response = nil
    if api_key and ApiKey.first(value: api_key)
      title = params[:title]
      user = params[:user]
      if title && user
        suggestion = Suggestion.create(
          title: title,
          user: user
        )

        if suggestion.saved?
          response = {
            suggestion: {
              title: title,
              user: user
            }
          }
        else
          response = {
            error: suggestion.errors.first.first
          }
        end
      else
        if !title
          response = {
            error: 'Missing / Invalid Title'
          }
        else
          response = {
            error: 'Missing / Invalid User'
          }
        end
      end
    end

    if response
      response.to_json
    else
      halt 404, {
       error: "Invalid Api Key #{api_key}"
      }.to_json
    end
  end

  # ------------------
  # Helpers
  # ------------------

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def external_link(link)
      /^http/.match(link) ? link : "http://#{link}"
    end

    # Returns a string truncated in the middle
    # Note: Rounds max_length down to nearest even number
    def truncate_string(string, max_length)
      if string.length > max_length
        # +/- 2 is to account for the elipse in the middle
        "#{string[0..(max_length/2)-2]}...#{string[-(max_length/2)+2..-1]}"
      else
        string
      end
    end

    def show_title_for_slug(slug)
      text = "Show Not Listed"
      if slug
        text = Shows.find_show_title(slug)
      end
      text
    end

    def suggestion_set_hr(suggestion_set)
      "<h2 class='show_break'>#{show_title_for_slug(suggestion_set.slug)}</h2>"
    end

    def link_to_vote_up(suggestion)
      html = ''
      # onclick returns false to keep from allowing
      html << "<a href='#' class='vote_up' onclick='return false;' data-id='#{suggestion.id}'>"
      html <<   "<span class='vote_arrow'/>"
      html << "</a>"
    end

    def link_and_vote_count(suggestion, user_ip)
      html = ''
      extra_classes = []
      if suggestion.user_already_voted?(user_ip)
        extra_classes << 'voted'
      else
        html << link_to_vote_up(suggestion)
      end
      html << "<span class='vote_count #{extra_classes.join(',')}'>#{suggestion.votes_counter}</span>"
    end

    def development?
      settings.development?
    end

    def cloud_json(cloud_data)
      return if cloud_data.nil?

      cloud_data.map do |d|
        {
          title: "#{show_title_for_slug(d[:show])} #{d[:time].to_date.to_s}",
          data: d[:data]
        }
      end.to_json
    end

  end # helpers

end
