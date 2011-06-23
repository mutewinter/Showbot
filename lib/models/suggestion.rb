require 'date'
require 'open-uri'
require 'json'

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

