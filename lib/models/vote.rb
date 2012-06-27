# vote.rb
#
# Model that contains a single vote for a user attached to a suggestion.

require 'dm-core'
require 'dm-validations'
require 'dm-types'
require 'dm-is-counter_cacheable'


class Vote

  include DataMapper::Resource
  is :counter_cacheable

  property :id,       Serial
  property :user_ip,  IPAddress,  :required => true, :default => '0.0.0.0', index: :user_ip_and_suggestion_id
  property :suggestion_id, Integer, index: [:suggestion_id, :user_ip_and_suggestion_id]

  # Assocations
  belongs_to :suggestion
  counter_cacheable :suggestion

end
