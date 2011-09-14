require 'open-uri'
require 'json'

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

class Suggestion
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,   :length => 40,
    :message => "That suggestion was too long. Showbot is sorry. Think title, not transcript."
  property :user,       String
  property :show,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :title

  validates_with_method :check_title_uniqueness

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
  # Validations
  # =====================
  
  # Verifies that title hasn't been entered in the last 30 minutes
  def check_title_uniqueness
    Suggestion.minutes_ago(30).each do |suggestion|
      if suggestion.title.downcase == self.title.downcase
        return [false, "Darn, #{suggestion.user} beat you to \"#{suggestion.title}\"."]
      end
    end

    return true
  end

  # =====================
  # Class Methods
  # =====================

  def self.recent(days_ago = 1)
    from = DateTime.now - days_ago
    all(:created_at.gt => from).all(:order => [:created_at.desc])
  end

  def self.minutes_ago(minutes)
    if minutes
      time_ago = Time.now - (60 * minutes)
      all(:created_at.gt => time_ago).all(:order => [:created_at.desc])
    end
  end
  
end
