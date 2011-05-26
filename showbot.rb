require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'json'

$debug = true

$domain = "http://5by5.tv"
$suggested_titles = []
$shows = []

def load_shows
  $shows = JSON.parse(File.open("shows.json").read)["shows"]
end

# Returns an array of titles for a given show
def get_titles_for_show(show)
  titles = []

  doc = Nokogiri::HTML(open("#{$domain}/#{show["url"]}"))
  
  shows_html = doc.css('div.episode/a')
  shows_html.each do |show_html|
    titles.push show_html.attribute "title"
  end
  titles
end

def get_show(show_string)
  $shows.each do |show|
    if show["url"].downcase == show_string.downcase
      return show
    elsif show["title"].downcase == show_string.downcase
      return show
    end
  end
  return nil
end


def reply_for_command(m, command_name="", arg1)
  reply = nil
  case command_name
  when "show"
    show = get_show(arg1)
    if show != nil
      reply = "#{m.user.nick}: #{$domain}/#{show["url"]}"
    else
      m.reply "#{m.user.nick}: No show by name #{arg1}"
      m.reply "Usage: !show show_name episode_number"
    end
  when "showtitles"
    show = get_show(arg1)
    if show != nil
      reply = get_titles_for_show(show).join("\n")
    else
      m.reply "#{m.user.nick}: No show by name #{arg1}"
      m.reply "Usage: !showtitles show_name"
    end
  when "suggest"
    if arg1 and arg1.strip != ""
      $suggested_titles.push arg1.strip
      reply = "Added title suggestion '#{arg1.strip}'"
    end
  when "suggestions"
    reply = "#{$suggested_titles.length} titles so far:\n"
    reply += $suggested_titles.join("\n")
  when "clear"
    reply = "Clearing #{$suggested_titles.length} title suggestions"
    $suggested_titles.clear
  when "stopfailing"
    reply = "no."
  else
    # no command found
  end
  
  return reply
end

# Main bot code
$bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    if $debug
      c.channels = ["#cinch-bots"]
    else
      c.channels = ["#5by5"]
    end
    c.nick = "showbot"
  end

  on :message, /^!(.+?)(?:$|\s)(.*?)\s*(\d*|next)$/ do |m, command, arg1, arg2|
    reply = reply_for_command(m, command, arg1)

    if reply and arg2 and arg2.strip != ""
      m.reply "#{reply}/#{arg2}"
    else
      m.reply reply if reply
    end
  end

end

def test
  p get_show("b2w")
  p get_show("afterdark")
  p get_show("BAcK to WoRk")
  p get_show("After Dark")
end

def main
  load_shows
  #test
  $bot.start
end

main
