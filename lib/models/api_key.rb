# DataMapper model for API keys for Showbot

require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

require 'securerandom'

class ApiKey
  include DataMapper::Resource

  property :id,         Serial
  property :value,      String,   :length => 16
  property :app_name,   String,   :length => 100

  # Create a random key automatically when making a new ApiKey
  before :create do
    # Must truncate since urlsafe_base64 doesn't generate the exact length
    self.value = SecureRandom.urlsafe_base64(16)[0...16]
  end

end
