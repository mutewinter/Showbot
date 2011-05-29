require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'nokogiri'

$domain = "http://5by5.tv"

# A class to manage Shows, woah
class Show
  attr_reader :title, :url, :rss, :keywords

  def initialize(json_hash)
    @title = json_hash["title"]
    @url = json_hash["url"]
    @rss = json_hash["rss"]
    @keywords = json_hash["keywords"]
  end

  def titles
    titles = []

    @rss_cache ||= RSS::Parser.parse(open(@rss), false)

    @rss_cache.items.each do |rss_item|
      titles.push rss_item.title
    end

    titles
  end

  # Description scraped from episode page
  def description(show_number)
    if valid_show?(show_number)
      doc = Nokogiri::HTML(open("#{$domain}/#{@url}/#{show_number}"))

      description = doc.css('div.episode_notes/p').first.text.strip
      return description
    else
      return "Show #{show_number} not found for #{@title}. Jackals."
    end
  end

  def links(show_number)
    links_array = []

    if valid_show?(show_number)
      doc = Nokogiri::HTML(open("#{$domain}/#{@url}/#{show_number}"))
      
      links_html = doc.css('div.links li a')
      links_html.each do |link|
        url = URI::escape(link.attribute("href").value)
        links_array.push "#{link.text} - #{url}"
      end
    end

    links_array
  end


  def valid_show?(show_number)
    return show_number.to_i < show_count
  end

  def show_count
    @rss_cache ||= RSS::Parser.parse(open(@rss), false)

    return @rss_cache.items.count
  end
end
