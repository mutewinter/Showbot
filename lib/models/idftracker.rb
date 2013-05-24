# idftracker.rb
#
# Model that tracks the information used to calculate IDF

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-aggregates'

class IdfTracker
  include DataMapper::Resource

  property :id,                   Serial
  property :last_suggestion_time, DateTime
  property :last_suggestion_show, String
  property :document_count,       Integer,  :default => 0
end
