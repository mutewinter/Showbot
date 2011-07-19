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

  validates_presence_of :title

  # =====================
  # Before Save
  # =====================

  before :save, :set_live_show
  before :save, :fix_title

  # Remove quotes from the title before saving
  def fix_title
    # Remove quotes if the user thought they needed them
    self.title = self.title.gsub(/^(?:'|")(.*)(?:'|")$/, '\1')
  end

  def set_live_show
    # Only fetch show from website if it wasn't set previously.
    if !self.show
      self.show = Shows.fetch_live_show_slug
    end
  end

  # =====================
  # Class Methods
  # =====================

  def self.recent(days_ago = 1)
    from = DateTime.now - days_ago
    all(:created_at.gt => from).all(:order => [:created_at.desc])
  end
  
end
