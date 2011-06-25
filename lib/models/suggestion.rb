require 'open-uri'
require 'json'

require 'dm-core'
require 'dm-validations'

LIVE_URL = 'http://5by5.tv/live/data.json'

class Suggestion
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,   :length => 100 # Limits title suggestions to 100 characters
  property :user,       String
  property :show,       String
  property :created_at, DateTime

  validates_presence_of :title


  # Class Methods
  
  # Fetches the slug for the live show
  def self.live_show_slug
    slug = nil

    live_hash = JSON.parse(open(LIVE_URL).read)

    if live_hash and live_hash.has_key?("live") and live_hash["live"]
      # Show is live, read show name
      broadcast = live_hash["broadcast"] if live_hash.has_key? "broadcast"
      slug = broadcast["slug"] if broadcast.has_key? "slug"
    end

    slug
  end

end
