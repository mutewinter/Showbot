# Class to hold all of the shows and some sweet helper methods

require 'json'

SHOWS_JSON = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "public", "shows.json"))

require File.expand_path(File.join(File.dirname(__FILE__), "show"))

class Shows

  # The array of shows loaded from the SHOWS_JSON file
  def self.shows
    if not defined? @@shows_array
      # Define the static @@shows_array variable if it doesn't exist
      @@shows_array = []
      show_hashes = JSON.parse(File.open(SHOWS_JSON).read)["shows"]
      show_hashes.each do |show_hash|
        @@shows_array.push Show.new(show_hash)
      end
    end

    @@shows_array
  end

  # Find a show by keyword (slug or part of the title)
  def self.find_show(keyword)
    if keyword
      self.shows.each do |show|
        if show.url.downcase == keyword.downcase
          return show
        elsif show.title.downcase.include? keyword.downcase
          return show
        end
      end
    end

    return nil # No show found, return nil
  end

  # Find a show title by keyword, or returns the keyword if the show doesn't exist
  def self.find_show_title(keyword)
    show = self.find_show(keyword)
    if show
      return show.title
    else
      return keyword
    end
  end

  # Get the live show slug
  def self.fetch_live_show_slug
    slug = nil

    begin
      live_hash = JSON.parse(open(LIVE_URL).read)
      if live_hash and live_hash.has_key?("live") and live_hash["live"]
        # Show is live, read show name
        broadcast = live_hash["broadcast"] if live_hash.has_key? "broadcast"
        slug = broadcast["slug"] if broadcast.has_key? "slug"
      end
    rescue OpenURI::HTTPError
      puts "Error: #{LIVE_URL} looks to be down."
    end

    return slug
  end

  # Returns the show object for the live show
  def self.fetch_live_show
    self.find_show(fetch_live_show_slug)
  end

end
