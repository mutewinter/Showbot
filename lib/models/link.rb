# link.rb
#
# DataMapper model for Link

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-types'
require 'open-uri'

class Link
  include DataMapper::Resource

  property :id,         Serial
  property :uri,        URI
  property :title,      String,   :length => 100
  property :user,       String
  property :show,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :uri

  validates_with_method :check_link_uniqueness

  # =====================
  # Before Save
  # =====================
  before :save, :set_live_show
  before :save, :fix_uri_scheme
  before :save, :fetch_page_title

  def set_live_show
    # Only fetch show from website if it wasn't set previously.
    if !self.show
      self.show = Shows.fetch_live_show_slug
    end
  end

  def fix_uri_scheme
    if self.uri.scheme.nil?
      # No scheme for URI, parse it again with http in front
      self.uri = Addressable::URI.parse("http://#{self.uri.to_s}")
    end
  end

  # Fetch the page title on a new thread so we don't block while requesting it
  def fetch_page_title
    Thread.new(self) do
      if self.title.nil? or self.title == ''
        begin
          self.update(:title => open(self.uri).read.match(/<title>(.*?)<\/title>?/i)[1])
        rescue URI::InvalidURIError
          puts "Failed to fetch title for #{self.uri}."
        end
      end
    end
  end

  # =====================
  # Validations
  # =====================
  
  # Verifies that link hasn't been entered in the last 30 minutes
  def check_link_uniqueness
    if self.uri
      Link.minutes_ago(30).each do |link|
        # Don't check uniqueness against itself
        if link.id != self.id and link.uri == self.uri
          return [false, "Darn, #{link.user} beat you to \"#{link.uri}\"."]
        end
      end
    else
      return true
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
