# cluster.rb
#
# Model that contains a set of similar title suggestions, determined by
# string metrics. 

require 'open-uri'
require 'json'

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-aggregates'

class Cluster
  include DataMapper::Resource

  property :id,       Serial
  
  # Associations
  has n, :suggestions

  # ------------------
  # Methods
  # ------------------

  def top_suggestion
    self.suggestions.all(:order => [:votes_counter.desc, :created_at.asc]).first
  end

  def total_votes
    self.suggestions.all.map(&:votes_counter).inject(0, :+)
  end

  def created_at
    top_suggestion.created_at
  end

  # ------------------
  # Class Methods
  # ------------------

  def self.recent(days_ago = 1)
    from = DateTime.now - days_ago
    all(:created_at.gt => from).all(:order => [:created_at.desc])
  end

end