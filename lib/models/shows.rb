# Class to hold all of the shows and some sweet helper methods

require 'json'

LIVE_URL = 'http://5by5.tv/live/data.json'

require File.expand_path(File.join(File.dirname(__FILE__), "show"))

class Shows < Array

  def initialize(json_file)
    super()
    import_json_file(json_file)
  end


  def import_json_file(json_file)
    show_hashes = JSON.parse(File.open(json_file).read)["shows"]
    show_hashes.each do |show_hash|
      self.push Show.new(show_hash)
    end
  end

  def find_show(keyword)
    if keyword
      self.each do |show|
        if show.url.downcase == keyword.downcase
          return show
        elsif show.title.downcase.include? keyword.downcase
          return show
        end
      end
    end
  end

  # =====================
  # Class Methods
  # =====================

  # Set the show from data.json on 5by5 before saving
  def self.fetch_live_show_slug
    slug = nil

    live_hash = JSON.parse(open(LIVE_URL).read)

    if live_hash and live_hash.has_key?("live") and live_hash["live"]
      # Show is live, read show name
      broadcast = live_hash["broadcast"] if live_hash.has_key? "broadcast"
      slug = broadcast["slug"] if broadcast.has_key? "slug"
    end

    return slug
  end

  # Returns the show object for the live show
  def self.fetch_live_show
    find_show(fetch_live_show_slug)
  end

end
