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
    self.value = SecureRandom.urlsafe_base64(16)
  end

end
