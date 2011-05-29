require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'nokogiri'

$domain = "http://5by5.tv"

# A class to manage Shows, woah
class Show
  attr_reader :title, :url, :rss


  def initialize(json_hash)
    @title = json_hash["title"]
    @url = json_hash["url"]
    @rss = json_hash["rss"]
  end

  def titles
    titles = []

    rss = RSS::Parser.parse(open(@rss), false)

    rss.items.each do |rss_item|
      titles.push rss_item.title
    end

    titles
  end

  # TODO pull this from the show page not RSS feed
  # since the RSS isn't updated and has blanks.
  def description(show_number)
    rss = RSS::Parser.parse(open(@rss), false)

    index = show_number.to_i - 1

    item = rss.items.reverse[index]

    if item
      return item.description
    else
      return "Show #{show_number} not found for #{@title}. Jackals."
    end
  end

  def links(show_number)
    links_array = []

    doc = Nokogiri::HTML(open("#{$domain}/#{@url}/#{show_number}"))
    
    links_html = doc.css('div.links li a')
    links_html.each do |link|
      url = URI::escape(link.attribute("href").value)
      links_array.push "#{link.text} - #{url}"
    end

    links_array
  end
end
