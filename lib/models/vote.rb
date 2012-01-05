# vote.rb
#
# Model that contains a single vote for a user attached to a suggestion.

require 'dm-core'
require 'dm-validations'
require 'dm-types'

class Vote

  include DataMapper::Resource

  property :id,       Serial
  property :user_ip,  IPAddress,  :required => true, :default => '0.0.0.0'

  # Assocations
  belongs_to :suggestion

end
