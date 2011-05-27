# A class to manage Shows, woah

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'nokogiri'

$domain = "http://5by5.tv"

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

  def description(show_number)
    rss = RSS::Parser.parse(open(@rss), false)

    rss.items[show_number.to_i].description
  end

  def links(show_number)
    links_array = []

    doc = Nokogiri::HTML(open("#{$domain}/#{@url}/#{show_number}"))
    
    links_html = doc.css('div.links li a')
    links_html.each do |link|
      links_array.push "#{link.text} - #{link.attribute("href").value}"
    end

    links_array
  end
end
