#!/usr/local/bin/ruby19
#
# Add the script directory as possible directory for files
dir = File.dirname(File.realdirpath(__FILE__))
$: << dir

require 'cinch'
require 'json'
require 'yaml'
require 'show.rb'
require 'commands.rb'

$test = false
$irc_test = false

if not $irc_test
  $nick = "showbot"
else
  $nick = "showbot_test"
end

$password = nil

$suggested_titles = []

$directory = File.dirname(__FILE__)

def load_shows
  shows = []
  show_hashes = JSON.parse(File.open(File.join($directory, "shows.json")).read)["shows"]
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
      c.nick = $nick
      c.password = $password if $password

      $shows ||= load_shows
    end

    on :message, /^!(.+?)(?:$|\s)(.*?)\s*(\d*|next)$/ do |m, command, arg1, arg2|

      commands ||= Commands.new(m, $shows)

      args = []

      args.push arg1 if arg1 and arg1.strip != ""
      args.push arg2 if arg2 and arg1.strip != ""

      # Call the method in Commands via method_missing
      commands.run(command, args)
    end
  end

  bot.start
end

def interactive_mode
  $shows ||= load_shows
  commands = Commands.new(nil, $shows)

  puts "Interactive mode, type commands and press enter (type quit to stop)."

  while true
    print "showbot> "
    response = STDIN::gets.strip
    case response
    when "quit", "exit"
      Process.exit
    when /^!(.+?)(?:$|\s)(.*?)\s*(\d*|next)$/
      args = []
      command = $1
      arg1 = $2
      arg2 = $3

      args.push arg1 if arg1 and arg1.strip != ""
      args.push arg2 if arg2 and arg1.strip != ""

      # Call the method in Commands via method_missing
      commands.run(command, args)
    end
  end
end


def test
  $shows ||= load_shows
  commands = Commands.new(nil, $shows)

  puts "\n============Should Work=============="
  commands.run("commands", [])
  commands.run("about", [])
  commands.run("next", [])
  commands.run("next", ["b2w"])
  commands.run("schedule", [])
  commands.run("description", ["talkshow", "10"])

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

  puts "\n============Should Fail (Out of range)=============="
  commands.run("description", ["the pipeline", "500"])

  puts "\n============Should Fail (Regular)=============="
  commands.run("taco", [])
  commands.run("description", ["Waffle City", "10"])
end


def main
  arg1 = ARGV.first
  if $test or arg1 == "test"
    puts "Running showbot tests."
    test
  elsif arg1 == "interactive"
    interactive_mode
  else
    if $nick == "showbot"
      if File.exists?(File.join($directory, "password.yml"))
        # Load the password since password.yml exists
        $password = tree = YAML::parse(File.open(File.join($directory, "password.yml")))['password'].value
      else
        puts "Enter NickServ password for showbot"
        $password = STDIN::gets.strip
      end
    end

    bot_start
  end
end

main
