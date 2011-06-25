require 'date'
require 'open-uri'
require 'json'

require 'dm-core'
require 'dm-validations'

class Suggestions < Array
  attr_reader :suggestions

  def add(title, user)
    self.push Suggestion.new(title, user)
  end

  def suggestions_after_time(time)
    self.collect{|s| next if s.created_at < time; s}.compact
  end

  def suggestions_for_title(slug)
    self.collect{|s| next if s.show != slug; s}.compact
  end

end


class Suggestion
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,   :length => 100 # Limits title suggestions to 100 characters
  property :user,       String
  property :created_at, DateTime

  validates_presence_of :title
end
