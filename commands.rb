require './show.rb'
require './random.rb'
require 'date'
require 'chronic_duration'
require 'ri_cal'
require './suggestion.rb'
require 'chronic'

$domain = "http://5by5.tv"

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

$eight_ball = ["It is certain",
               "It is decidedly so",
               "Without a doubt",
               "Yes - definitely",
               "You may rely on it",
               "As I see it, yes",
               "Most likely",
               "Outlook good",
               "Signs point to yes",
               "Yes",
               "Reply hazy, try again",
               "Ask again later",
               "Better not tell you now",
               "Cannot predict now",
               "Concentrate and ask again",
               "Don't count on it",
               "My reply is no",
               "My sources say no",
               "Outlook not so good",
               "Very doubtful"]
$paleo = [
  "You wouldn't be tired.",
  "Your insulin wouldn't be spiking.",
  "Elk.",
  "No glutens."
]

$jsir = ["perl -le '$n=10; $min=5; $max=15; $, = \" \"; print map { int(rand($max-$min))+$min } 1..$n",
         "perl -le '$i=3; $u += ($_<<8*$i--) for \"127.0.0.1\" =~ /(\d+)/g; print $u'",
         "perl -MAlgorithm::Permute -le '$l = [1,2,3,4,5]; $p = Algorithm::Permute->new($l); print @r while @r = $p->next'",
         "perl -lne '(1x$_) !~ /^1?$|^(11+?)\\1+$/ && print \"$_ is prime\"'",
         "perl -ple 's/^[ \\t]+|[ \\t]+$//g'"]

$ical = "http://www.google.com/calendar/ical/fivebyfivestudios%40gmail.com/public/basic.ics"

# Class to define the possible irc commands
class Commands
  @@command_usage = {
    about: 'Who made this?',
    description: '!description show_name episode_number',
    suggest: '!suggest title_suggestion',
    suggestions: '!suggestions [show|relative_time (e.g. 3 hours ago)]',
    next: '!next [show_name]',
    schedule: 'Prints a list of upcoming shows on 5by5'
  }

  # Array to hold history of commands
  @@history = []

  def initialize(message, shows)
    @@admin_key ||= (0...8).map{65.+(rand(25)).chr}.join
    puts "Admin key is #{@@admin_key}"
    # IRC message object from cinch
    @message = message
    # Shows is a class variable since it shouldn't change while the bot is running
    @@shows ||= shows
    @@suggestions ||= Suggestions.new

  end
  
  def start_refresh_thread
    @@refresh_thread ||= Thread.new do 
      until false
        puts "Refreshing calendar cache"
        @@calendar_cache = RiCal.parse(open($ical))
        puts "Sleeping 10 minutes until next refresh"
        sleep 600
      end
    end
  end

  def get_show(show_string)
    if show_string
      @@shows.each do |show|
        if show.url.downcase == show_string.downcase
          return show
        elsif show.title.downcase.include? show_string.downcase
          return show
        end
      end
    end
    return nil
  end

  def usage(command="")
    if command
      return "Usage: #{@@command_usage[command.to_sym]}"
    end
  end
  #
  # Prints text without replying to user who issued command
  def chat(text)
    if text and text.strip != ""
      if @message
        #@message.user.send text
        @message.reply text
      else
        # Debug mode
        puts text
      end
    end
  end

  # Prints text and replies to user who issued the command
  def reply(text)
    if text and text.strip != ""
      if @message
        @message.user.send text
      else
        # Debug mode
        chat("Reply: #{text}")
      end
    end
  end

  def run(command, args)
    real_command = "command_#{command}"
    if self.respond_to? real_command
      if @message
        @@history << HistoryEvent.new(command, args, @message.user.nick, Time.now)
      else
        @@history << HistoryEvent.new(command, args, "debug_user", Time.now)
      end
      self.send(real_command, args)
    else
      puts "Unrecognized command #{command}"
    end
  end

  def show_error(show, show_number)
    if show_number == 1
      reply("#{show.title} only has #{show.show_count} episode.")
    else
      reply("#{show.title} only has #{show.show_count} episodes.")
    end
  end

  def admin_key
    @@admin_key
  end

  def history
    @@history
  end
  
  # --------------
  # Regular Commands
  # --------------
  
  # Replies to the user with a list of available commands for showbot
  # !commands
  def command_commands(args = [])
    reply("Available commands:")
    @@command_usage.each_pair do |command, usage|
      reply("  !#{command} - #{usage}")
    end
  end

  # Alias for the !commands command
  def command_help(args = [])
    command_commands(args)
  end

  # Replies to the user with information about showbot
  def command_about(args = [])
    reply("Showbot was created by Jeremy Mack (@mutewinter) and some awesome contributors on github. The project page is located at https://github.com/mutewinter/Showbot")
    reply("Type !commands for showbot's commands")
  end

  # Alias for the about command
  def command_showbot(args = [])
    command_about(args)
  end

  # Replies to the user with information about the next show
  # !next b2w -> The next Back to Work is in 3 hours 30 minutes (6/2/2011)
  def command_next(args = [])
    @@calendar_cache ||= RiCal.parse(open($ical))
    
    # Start the calendar refresh thread
    start_refresh_thread

    show = get_show(args.first) if args.length > 0

    nearest_event = nil
    nearest_seconds_until = nil
    @@calendar_cache.first.events.each do |event|
      # Grab the next occurrence for the event
      event = (event.occurrences({:starting => DateTime.now, :count => 1})).first
      
      if event and event.start_time > DateTime.now
        seconds_until = ((event.start_time - DateTime.now) * 24 * 60 * 60).to_i
        summary = event.summary
        if show and get_show(summary.strip.downcase) == show
          if !nearest_seconds_until
            nearest_seconds_until = seconds_until
            nearest_event = event
          elsif seconds_until < nearest_seconds_until
            nearest_seconds_until = seconds_until
            nearest_event = event
          end
        elsif !show
          if !nearest_seconds_until
            nearest_seconds_until = seconds_until
            nearest_event = event
          elsif seconds_until < nearest_seconds_until
            nearest_seconds_until = seconds_until
            nearest_event = event
          end
        end
      end
    end

    if nearest_event
      date_string = nearest_event.start_time.strftime("%-m/%-d/%Y")
      time_string = nearest_event.start_time.strftime("%-I:%M%P")
      if show
        reply("The next #{nearest_event.summary} is in #{ChronicDuration.output(nearest_seconds_until, :format => :long)} (#{time_string} on #{date_string})")
      else 
        reply("Next show is #{nearest_event.summary} in #{ChronicDuration.output(nearest_seconds_until, :format => :long)} (#{time_string} on #{date_string})")
      end
    else
      reply("No upcoming show found for #{show.title}")
    end

  end

  def command_schedule(args = [])
    @@calendar_cache ||= RiCal.parse(open($ical))
    
    # Start the calendar refresh thread
    start_refresh_thread

    upcoming_events = []

    @@calendar_cache.first.events.each do |event|
      # Grab the next occurrence for the event
      event = (event.occurrences({:starting => Date.today, :count => 1})).first

      upcoming_events << event if event
    end

    if upcoming_events.length > 0
      reply("#{upcoming_events.length} upcoming show#{upcoming_events.length > 1 ? "s" : ""}")
      upcoming_events.sort{|e1, e2| e1.start_time <=> e2.start_time}.each do |event|
        date_string = event.start_time.strftime("%-m/%-d/%Y")
        time_string = event.start_time.strftime("%-I:%M%P")
        reply("  #{event.summary} on #{date_string} at #{time_string}")
      end
    end

  end

  # --------------
  # Show Commands
  # --------------
  
  # Replies to the user with the description of the show episode they specify
  # !description Hypercritical 10 -> John Siracusa and Dan Benjamin are bri...
  def command_description(args = [])
    if args.length < 2
      reply(usage("description"))
    else
      show = get_show(args.first)
      show_number = args[1].strip

      if show
        if show_number and show.valid_show?(show_number)
          reply(show.description(show_number))
        elsif show_number and show_number != ""
          show_error(show, show_number)
        end
      else
        reply(usage("description"))
      end
    end
  end
    
  # --------------
  # Suggestion Commands
  # --------------

  # Adds the show title suggestion the user specifies
  # !suggest Walking Tacos -> Added title suggestion "Walking Tacos"
  def command_suggest(args = [])
    suggestion = args.first.strip if args.length > 0
    if suggestion and suggestion != ""
      if @message
        @@suggestions.add(suggestion, @message.user.nick)
      else
        @@suggestions.add(suggestion, nil)
      end
      reply("Added title suggestion \"#{suggestion}\"")
    else
      reply(usage("suggest"))
    end
  end

  # Replies to the user with the current show title suggestions
  # !suggestions 2 hours ago -> Suggestions in the last two hours <omg spam here>
  def command_suggestions(args = [])
    if @@suggestions.length == 0
      reply('There are no suggestions. You should add some by using "!suggest title_suggestion".')
    else
      if args.first
        time = Chronic.parse(args.first)
        show = get_show(args.first)
        if time
          matching_suggestions = @@suggestions.suggestions_after_time(time)
          if matching_suggestions.length > 0
            reply("#{matching_suggestions.length} suggestion(s) from #{time.strftime("%I:%M%P EST")} onward:")
            reply(matching_suggestions.join("\n"))
          else
            reply("No suggestions after #{time.strftime("%I:%M%P EST")}.")
          end
        elsif show
          matching_suggestions = @@suggestions.suggestions_for_title(show.url)
          if matching_suggestions.length > 0
            reply("#{matching_suggestions.length} titles for #{show.title}:\n")
            reply(matching_suggestions.join("\n"))
          else
            reply("There are no suggestions for #{show.title}. You should add some by using \"!suggest title_suggestion\".")
          end
        else
          reply("Show \"#{args.first}\" not found.")
          reply(usage("suggestions"))
        end
      else
        default_time = Chronic.parse("3 hours ago")
        suggestions = @@suggestions.suggestions_after_time(default_time)

        reply("#{suggestions.length} titles in the last 3 hours:\n")
        reply(suggestions.join("\n"))
      end
    end
  end

  
  # --------------
  # Admin Commands
  # --------------

  # Admin command that shows the recently executed commands
  # !exit @@admin_key
  def command_history(args = [])
    if args.first == @@admin_key
      amount = args[1].to_i if args.length > 1
      history = []
      if amount and amount < @@history.length
        history = @@history[(-amount)..-1]
      else
        history = @@history
      end
      reply("Showing last #{history.length} command#{history.length > 1 ? "s" : ""} of #{@@history.length}.")
      reply(history.join("\n"))
    else
      puts "Invalid admin key #{args.first}, should be #{@@admin_key}"
    end
  end

  # Admin command that tells the bot to exit
  # !exit @@admin_key
  def command_exit(args = [])
    if args.first == @@admin_key
      reply("Showbot is shutting down. Good bye :(")
      Process.exit
    else
      puts "Invalid admin key #{args.first}, should be #{@@admin_key}"
    end
  end

  # Clears the title suggestions
  # !clear @@admin_key
  def command_clear(args = [])
    if args.first == @@admin_key
      if @@suggestions.length == 1
        reply("Clearing 1 title suggestion.")
      elsif @@suggestions.length == 0
        reply("There are no suggestions to clear. You can start adding some by using \"!suggest title_suggestion\".")
      else
        # Printing current suggestions so they aren't lost due to a malicious !clear
        reply("Clearing #{@@suggestions.length} title suggestions.")
      end
      @@suggestions.clear
    else
      puts "Invalid admin key #{args.first}, should be #{@@admin_key}"
    end
  end

  # --------------
  # Fun commands
  # --------------

  def command_stopfailing(args = [])
    chat("no.")
  end

  def command_merlin(args = [])
    chat("SO angry.")
  end

  def command_drphil(args = [])
    chat("\"#{$drphil.random}\"")
  end

  def command_sandy(args = [])
    chat("He's great.")
  end

  def command_gruber(args = [])
    chat("I don't know.")
  end

  def command_jsir(args = [])
    chat($jsir.random)
  end

  def command_paleo(args = [])
    chat($paleo.random)
  end

  def command_8ball(args = [])
    chat("#{$eight_ball.random}.")
  end

end

HistoryEvent = Struct.new(:command, :args, :user, :time) do
  def to_s
    time_string = time.strftime("%-m/%-d/%Y at %-I:%M:%S%P")
    "#{user}: !#{command} #{args.join(" ")} on #{time_string}"
  end
end


