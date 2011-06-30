# Class to hold all of the shows and some sweet helper methods

require 'json'

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

  def live_show
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
