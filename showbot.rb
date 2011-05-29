require 'cinch'
require 'json'
require './show.rb'
require './random.rb'

$debug = false

$domain = "http://5by5.tv"
$suggested_titles = []
$shows = []
$drphil = ["There's a genie for that.",
 "Everything's a bear.",
 "A beret will be fine.",
 "If you want to find the treasure you gotta buy the chest!",
 "You don't win at tennis by buying a bowling ball.",
 "If you live in a tree, don't be surprised that you're living with monkeys.",
 "Crush the Bunny.",
 "Doesn't matter how many Fords you buy, they're never gonna be a Dodge. You can repaint the Ford but... let's go to a break.",
 "You're not gonna get Black Lung from an excel spreadsheet.",
 "I'm not gonna euthanize this dog, I'm just gonna put it over here where I can't see it.",
 "Failure is the equivalent of existential sit-ups."]

def load_shows
  show_hashes = JSON.parse(File.open("shows.json").read)["shows"]
  show_hashes.each do |show_hash|
    $shows.push Show.new(show_hash)
  end
end


def get_show(show_string)
  $shows.each do |show|
    if show.url.downcase == show_string.downcase
      return show
    elsif show.title.downcase == show_string.downcase
      return show
    end
  end
  return nil
end


def reply_for_command(m, command_name="", arg1, arg2)
  reply = nil
  case command_name
  when "show"
    show = get_show(arg1)
    if show
      reply = "#{m.user.nick}: #{$domain}/#{show.url}"
    else
      m.reply "#{m.user.nick}: No show by name \"#{arg1}\". You dissappoint."
      m.reply "#{m.user.nick}: Usage: !show show_name episode_number"
    end
  when "links"
    show = get_show(arg1)
    if show and arg2 and arg2.strip != ""
      reply = "#{m.user.nick}: #{show.links(arg2).join("\n")}"
    end
  when "description"
    show = get_show(arg1)
    if show and arg2 and arg2.strip != ""
      reply = "#{m.user.nick}: #{show.description(arg2)}"
    end
  when "titles"
    show = get_show(arg1)
    if show
      reply = show.titles.join("\n")
    else
      m.reply "#{m.user.nick}: No show by name #{arg1}."
      m.reply "#{m.user.nick}: Usage: !titles show_name"
    end
  when "suggest"
    if arg1 and arg1.strip != ""
      $suggested_titles.push arg1.strip
      reply = "Added title suggestion \"#{arg1.strip}\""
    end
  when "suggestions"
    if $suggested_titles.length == 0
      reply = "There are no suggestions. You should add some by using \"!suggest title_suggestion\"."
    else
      reply = "#{$suggested_titles.length} titles so far:\n"
      reply += $suggested_titles.join("\n")
    end
  when "clear"
    if $suggested_titles.length == 1
      reply = "Clearing #{$suggested_titles.length} title suggestion."
    elsif $suggested_titles.length == 0
      reply = "There are no suggestions to clear. You can start adding some by using \"!suggest title_suggestion\"."
    else
      reply = "Clearing #{$suggested_titles.length} title suggestions."
    end
    $suggested_titles.clear
  when "stopfailing"
    reply = "no."
  when "merlin"
    reply = "SO angry."
  when "drphil"
    reply = "From the wise Mr. Mann: \"#{$drphil.random}\"."
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
    reply = reply_for_command(m, command, arg1, arg2)

    if reply and arg2 and arg2.strip != "" and command.strip == "show"
      m.reply "#{reply}/#{arg2}"
    else
      m.reply reply if reply
    end
  end

end

def test
  b2w = get_show("b2w")
  talkshow = get_show('talkshow')

  # Should work
  puts talkshow.description("100")
  puts b2w.description("17")

  # Should fail
  puts talkshow.description("50")
  puts b2w.description("100")
end

def main
  load_shows
  #test
  $bot.start
end

main
