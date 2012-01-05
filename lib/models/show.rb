# A class to hold the data for a Show, woah

class Show
  attr_reader :title, :url, :rss

  def initialize(json_hash)
    @title = json_hash["title"]
    @url = json_hash["url"]
    @rss = json_hash["rss"]
  end
end
