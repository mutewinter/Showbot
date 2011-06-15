require 'date'
require 'open-uri'
require 'json'

class Suggestions < Array
  attr_reader :suggestions

  def add(title, user)
    self.push Suggestion.new(title, user)
  end

  def suggestions_after_time(time)
    self.collect{|s| next if s.time < time; s}.compact
  end

  def suggestions_for_title(slug)
    self.collect{|s| next if s.show != slug; s}.compact
  end

end

class Suggestion
  attr_reader :title, :user, :time, :show

  @@live_url = 'http://5by5.tv/live/data.json'

  def initialize(title, user)
    @title = title
    @user = user
    @time = Time.now
    @show = fetch_live_show
  end
  
  def to_s
    if @user
      "#{@title} (#{@user})"
    else
      "#{@title}"
    end
  end
  
  def fetch_live_show
    show_name = nil

    live_hash = JSON.parse(open(@@live_url).read)

    if live_hash and live_hash.has_key?("live") and live_hash["live"]
      # Show is live, read show name
      broadcast = live_hash["broadcast"] if live_hash.has_key? "broadcast"
      show_name = broadcast["slug"] if broadcast.has_key? "slug"
    end

    show_name
  end
end
