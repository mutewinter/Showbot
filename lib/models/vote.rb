require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'

class Vote
    include DataMapper::Resource

    property :id,   Serial
    property :user, String, :length => 100
    belongs_to :suggestion

    validates_presence_of :user
end
