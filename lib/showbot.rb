# Add the script directory as possible directory for files
dir = File.dirname(File.realdirpath(__FILE__))
$: << dir

# =================
# Dependencies
# =================

# Gems
require 'cinch'
require 'json'
require 'yaml'

# Showbot Files
require 'showbot/show'
require 'showbot/commands'

module Showbot
  class Bot
    attr_reader :nick, :irc_test

    # Initialize method for showbot
    def initialize(nick = "showbot")
      # Must use class variables so it works in Bot.new block below
      @@nick = nick


      # Loads the shows if from JSON if they haven't been loaded
      @@shows ||= load_shows

      @commands = Commands.new(nil, @@shows)
    end


    # =================
    # Bot Accessor Methods
    # =================

    def suggestions
      @commands.suggestions
    end

    # Return the Cinch bot
    def bot
      @bot
    end

    
    # =================
    # Bot State Methods
    # =================

    # Runs bot and connects to IRC
    def start
      @bot = Cinch::Bot.new do
        configure do |c|
          c.server = "irc.freenode.org"
          c.channels = ["#5by5"]

          c.nick = @@nick
          c.password = ENV['SHOWBOT_IRC_PASSWORD']
        end

        on :message, /^!(.+?)(?:$|\s)(.*?)\s*(\d*|next)$/ do |m, command, arg1, arg2|

          @commands ||= Commands.new(m, @@shows)

          args = []

          args.push arg1 if arg1 and arg1.strip != ""
          args.push arg2 if arg2 and arg1.strip != ""

          # Call the method in Commands via method_missing
          @commands.run(command, args)
        end
      end

      @bot.start
    end

    # Runs in interactive mode, expecting commands from STDIN
    def interactive_mode
      @@shows ||= load_shows
      @commands = Commands.new(nil, @@shows)

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
          @commands.run(command, args)
        end
      end
    end

    def suggestion_test
      @commands = Commands.new(nil, @@shows)

      @commands.run("suggest", ["Small title"])
      @commands.run("suggest", ["Medium title here, hi."])
      @commands.run("suggest", ["This is a huge title with lowercase caps thank god."])
      @commands.run("suggest", ["Two line title hopefully here."])
      @commands.run("suggest", ["Title"])
    end

    # Runs tests
    def test
      @commands = Commands.new(nil, @@shows)

      puts "\n============Should Work=============="
      @commands.run("commands", [])
      @commands.run("about", [])
      @commands.run("next", [])
      @commands.run("next", ["b2w"])
      @commands.run("schedule", [])
      @commands.run("description", ["talkshow", "10"])
      @commands.run("history", [@commands.admin_key, "10"])

      puts "\n============Should Work (Suggestions)=============="
      @commands.run("suggest", ["Chickens and Ex-Girlfriends"])
      @commands.run("suggest", ["The Programmer Barn"])
      @commands.run("suggest", ["The Bridges of Siracusa County"])
      @commands.run("suggestions", [])
      @commands.run("suggestions", ["5 minutes ago"])

      puts "\n============Should Fail (Suggestions)=============="
      @commands.run("suggestions", ["in 2 hours"])
      @commands.run("suggestions", ["tacos"])

      puts "\n============Should Work (Clearing Suggestions)=============="
      @commands.run("clear", [@commands.admin_key])

      puts "\n============Should Fail (Out of range)=============="
      @commands.run("description", ["the pipeline", "500"])

      puts "\n============Should Fail (Regular)=============="
      @commands.run("taco", [])
      @commands.run("description", ["Waffle City", "10"])

      puts "\n============Should Work=============="
      @commands.run("uptime", [])
    end

    # =================
    # Private Methods
    # =================

    # Loads the shows from shows.json
    def load_shows
      shows = []
      show_hashes = JSON.parse(File.open("public/shows.json").read)["shows"]
      show_hashes.each do |show_hash|
        shows.push Show.new(show_hash)
      end
      return shows
    end

  end
end
