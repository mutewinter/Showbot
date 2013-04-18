# suggestion.rb
#
# Model that contains a title suggestion. These are created from the IRC chat
# bot via !suggest

require 'open-uri'
require 'json'

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-aggregates'

class Suggestion
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,   :length => 40,
    :message => "That suggestion was too long. Showbot is sorry. Think title, not transcript."
  property :user,       String
  property :show,       String
  property :created_at, DateTime, index: true
  property :updated_at, DateTime

  validates_presence_of :title
  validates_with_method :title, :check_title_uniqueness, :if => :new?

  # Assocations
  has n, :votes
  belongs_to :cluster, :required => false

  # ------------------
  # Before Save
  # ------------------

  before :save, :fix_title

  # Remove quotes from the title before saving
  def fix_title
    # Remove quotes if the user thought they needed them
    self.title = self.title.gsub(/^(?:'|")(.*)(?:'|")$/, '\1')
  end

  before :create, :check_cluster

  def check_cluster
    Suggestion.minutes_ago(30).each do |suggestion|
      if suggestion.id != self.id and lev_sim(suggestion) > 0.7
        if suggestion.in_cluster?
          suggestion.cluster.suggestions << self
          self.cluster = suggestion.cluster
          suggestion.cluster.save
        else
          cluster = Cluster.create
          cluster.suggestions << suggestion
          cluster.suggestions << self
          self.cluster = cluster
          cluster.save
        end
        return true
      end
    end
    true
  end

  before :create, :set_live_show

  def set_live_show
    # Only fetch show from website if it wasn't set previously.
    if !self.show
      self.show = Shows.fetch_live_show_slug
    end

    true
  end

#  after :save, :debug_cluster_id

#  def debug_cluster_id
#    $stderr.puts "After save, #{self.title}'s cluster_id is #{self.cluster_id}"
#  end

  # ------------------
  # Validations
  # ------------------

  # Verifies that title hasn't been entered in the last 30 minutes
  def check_title_uniqueness
    if self.title
      Suggestion.minutes_ago(30).each do |suggestion|
        if suggestion.title.downcase == self.title.downcase
          return [false, "Darn, #{suggestion.user} beat you to \"#{suggestion.title}\"."]
        end
      end
    else
      return true
    end
    return true
  end

  # ------------------
  # Class Methods
  # ------------------

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

  # Group suggestions by show slug
  #
  # Returns an array of SuggestionSets (see the bottom of this file)
  def self.group_by_show
    suggestion_sets = []
    last_show = nil
    last_time = nil
    split_interval = 0.75 # 18 hours - for creating a new set if same show runs 2 days in a row without another in between

    all.each do |suggestion|
      if suggestion_sets.empty? or last_show != suggestion.show or (last_time - suggestion.created_at) > split_interval
        suggestion_sets << SuggestionSet.new(suggestion.show)
      end

      last_show = suggestion.show
      last_time = suggestion.created_at

      # Always add the show to the last group
      suggestion_sets.last.add suggestion
    end

    suggestion_sets
  end

  # ------------------
  # Helper Methods
  # ------------------

  # Voting

  # Add a vote to the votes assocation for the user's IP
  #
  # Returns true if successful and false if the user has already voted.
  def vote_up(user_ip)
    if user_already_voted?(user_ip)
      false
    else
      if self.votes.create(:user_ip => user_ip)
        true
      else
        false
      end
    end
  end

  # Determine if a user has already voted on this suggestion from this IP address.
  #
  # Returns true if user has not voted on this suggestion.
  def user_already_voted?(user_ip)
    self.votes.all(:user_ip => user_ip).count > 0
  end

  def to_s
    "#{self.title} by #{self.user}"
  end

  def update_votes_counter_cache
    vote_count = self.votes.count
    if vote_count != self.votes_counter
      puts "Fixing missmatched count (#{vote_count}/#{self.votes_counter} for #{self})"
      self.update(:votes_counter => self.votes.count)
    end
  end

  # Clustering

  def lev_sim(other_suggestion)
    distance = levenshtein(self.title.downcase,
                           other_suggestion.title.downcase)

    1.0 - distance.to_f / [self.title.length, other_suggestion.title.length].max
  end

  def in_cluster?
    !!self.cluster_id
  end

  def top_of_cluster?
    if self.in_cluster?
      self.id == self.cluster.top_suggestion.id
    else
      true # would be the top if it were in a cluster by itself
    end
  end

  def total_for_cluster
    self.in_cluster? ? self.cluster.total_votes : self.votes.count
  end

end


# Class to hold sets of suggestions for the group_by_show method of Suggestion
class SuggestionSet
  def initialize(slug = nil)
    @slug = slug
    @suggestions = []
    super
  end

  def add(show)
    @suggestions << show
  end

  def to_s
    string = ""
    string << "Show #@slug\n"
    string << "  Titles:\n"
    string << @suggestions.map{|s| "  #{s.title}"}.join("\n")
    string
  end

  attr_accessor :slug, :suggestions
end

# https://github.com/threedaymonk/text/blob/master/lib/text/levenshtein.rb
def levenshtein(str1, str2)
  ar1 = str1.split(//)
  ar2 = str2.split(//)

  d = (0..ar2.length).to_a
  x = nil

  ar1.length.times do |i|
    e = i + 1
    ar2.length.times do |j|
      cost = (ar1[i] == ar2[j]) ? 0 : 1;
      x = [ d[j+1] + 1, e + 1, d[j] + cost].min
      d[j] = e
      e = x
    end
    d[ar2.length] = x
  end

  x
end
