require 'open-uri'
require 'json'

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

LIVE_URL = 'http://5by5.tv/live/data.json'

class Suggestion
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,   :length => 100,
    :message => "Suggestion NOT recorded. Showbot is sorry. Think title, not transcript."
  property :user,       String
  property :show,       String
  property :created_at, DateTime
  property :updated_at, DateTime
  has n, :votes

  validates_presence_of :title

  before :save, :fetch_show
  before :save, :fix_title

  # Remove quotes from the title before saving
  def fix_title
    # Remove quotes if the user thought they needed them
    self.title = self.title.gsub(/^(?:'|")(.*)(?:'|")$/, '\1')
  end

  # Set the show from data.json on 5by5 before saving
  def fetch_show
    live_hash = JSON.parse(open(LIVE_URL).read)

    if live_hash and live_hash.has_key?("live") and live_hash["live"]
      # Show is live, read show name
      broadcast = live_hash["broadcast"] if live_hash.has_key? "broadcast"
      self.show = broadcast["slug"] if broadcast.has_key? "slug"
    end
  end

  def vote_up(user_ip)
    if self.votes.all(:user => user_ip).count == 0
      Vote.create(:user => user_ip, :suggestion => self)
      "#{self.votes.count}"
    else
      "You have already voted on this suggestion."
    end
  end

  def Suggestion.recent(days_ago = 1)
    from = DateTime.now - days_ago
    Suggestion.all(:created_at.gt => from).all(:order => [:created_at.desc])
  end
end
