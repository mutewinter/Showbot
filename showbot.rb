require 'cinch'
require 'json'
require './show.rb'
require './commands.rb'

$debug = true

$suggested_titles = []

def load_shows
  shows = []
  show_hashes = JSON.parse(File.open("shows.json").read)["shows"]
  show_hashes.each do |show_hash|
    shows.push Show.new(show_hash)
  end
  return shows
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

    $shows ||= load_shows
  end

  on :message, /^!(.+?)(?:$|\s)(.*?)\s*(\d*|next)$/ do |m, command, arg1, arg2|

    commands = Commands.new(m, $shows)

    args = []
    
    args.push arg1 if arg1 and arg1.strip != ""
    args.push arg2 if arg2 and arg1.strip != ""

    # Call the method in Commands via method_missing
    commands.run(command, args)
  end

end

def test
  b2w = get_show("b2w")
  talkshow = get_show('talkshow')

  # Should work
  puts talkshow.description("43")
  puts b2w.description("17")

  # Should fail
  puts talkshow.description("200")
  puts b2w.description("200")
end

def main
  #test
  $bot.start
end

main
