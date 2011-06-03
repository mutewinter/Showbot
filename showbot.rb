require 'cinch'
require 'json'
require './show.rb'
require './commands.rb'

$debug = false
$irc_test = false

$suggested_titles = []

def load_shows
  shows = []
  show_hashes = JSON.parse(File.open("shows.json").read)["shows"]
  show_hashes.each do |show_hash|
    shows.push Show.new(show_hash)
  end
  return shows
end

# Run bot
def bot_start
  bot = Cinch::Bot.new do
    configure do |c|
      c.server = "irc.freenode.org"
      if $irc_test
        c.channels = ["#cinch-bots"]
      else
        c.channels = ["#5by5"]
      end
      c.nick = "showbot"

      $shows ||= load_shows
    end

    on :message, /^!(.+?)(?:$|\s)(.*?)\s*(\d*|next)$/ do |m, command, arg1, arg2|

      @commands ||= Commands.new(m, $shows)

      args = []

      args.push arg1 if arg1 and arg1.strip != ""
      args.push arg2 if arg2 and arg1.strip != ""

      # Call the method in Commands via method_missing
      @commands.run(command, args)
    end
  end
  bot.start
end

def test
  $shows ||= load_shows
  commands = Commands.new(nil, $shows)


  puts "\n============Should Work=============="
  commands.run("commands", [])
  commands.run("about", [])
  commands.run("show", ["b2w"])
  commands.run("next", [])
  commands.run("next", ["b2w"])
  commands.run("show", ["anal", "13"])
  commands.run("show", ["work", "next"])
  commands.run("description", ["talkshow", "10"])
  commands.run("links", ["the pipeline", "5"])

  puts "\n============Should Work (Suggestions)=============="
  commands.run("suggest", ["Chickens and Ex-Girlfriends"])
  commands.run("suggest", ["The Programmer Barn"])
  commands.run("suggest", ["The Bridges of Siracusa County"])
  commands.run("suggestions", [])
  commands.run("suggestions", ["5 minutes ago"])

  puts "\n============Should Fail (Suggestions)=============="
  commands.run("suggestions", ["in 2 hours"])
  commands.run("suggestions", ["tacos"])

  puts "\n============Should Work (Clearing Suggestions)=============="
  commands.run("clear", [commands.admin_key])
  commands.run("suggestions", []) # Should print out text for no suggestions

  puts "\n============Should Fail (Out of range)=============="
  commands.run("show", ["b2w", "500"])
  commands.run("links", ["talkshow", "500"])
  commands.run("description", ["the pipeline", "500"])

  puts "\n============Should Fail (Regular)=============="
  commands.run("taco", [])
  commands.run("show", ["Large Dogs"])
  commands.run("show", ["Smallish Dogs", "13"])
  commands.run("description", ["Waffle City", "10"])
  commands.run("links", ["The Link Show", "5"])
end


def main
  arg1 = ARGV.first
  if $debug or arg1 == "debug"
    test
  else
    bot_start
  end
end

main
