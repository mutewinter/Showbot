# link.rb
#
# DataMapper model for Link

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-types'
require 'open-uri'
require 'openssl'

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
  # Before Create
  # =====================
  before :create, :set_live_show

  def set_live_show
    # Only fetch show from website if it wasn't set previously.
    if !self.show
      self.show = Shows.fetch_live_show_slug
    end

    true # Since this hook shouldn't keep the link from saving
  end

  # =====================
  # After Create
  # =====================

  # Fetch the page title on a new thread so we don't block while requesting it
  after :create do |link|
    fetch_page_title(link)
  end

  def fetch_page_title(link)
    Thread.new(link) do
      begin
        link.update(:title => open(link.uri, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read.match(/<title>(.*?)<\/title>?/im)[1])
      rescue URI::InvalidURIError
        STDOUT::puts "Failed to fetch title for #{link.uri}."
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
          return [false, "Darn, #{link.user} beat you to #{link.uri}."]
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
