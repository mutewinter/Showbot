require './show.rb'
require './random.rb'

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

# Class to define the possible irc commands
class Commands
  @@command_usage = {
    show: '!show show_name [episode_number]',
    links: '!links show_name episode_number',
    suggest: '!suggest title_suggestion',
    suggestions: 'There are no suggestions. You should add some by using \"!suggest title_suggestion\".',
    clear: 'Clears all titles'
  }

  def initialize(message, shows)
    # IRC message object from cinch
    @message = message
    # Shows is a class variable since it shouldn't change while the bot is running
    @@shows ||= shows
    @@suggested_titles ||= []
  end

  def get_show(show_string)
    @@shows.each do |show|
      if show.url.downcase == show_string.downcase
        return show
      elsif show.title.downcase == show_string.downcase
        return show
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
      @message.reply text
    end
  end

  # Prints text and replies to user who issued the command
  def reply(text)
    if text and text.strip != ""
      chat("#{@message.user.nick}: #{text}")
    end
  end


  def run(command, args)
    real_command = "command_#{command}"
    if self.respond_to? real_command
      self.send(real_command, args)
    else
      puts "Unrecognized command #{command}"
    end
  end
  
  # --------------
  # Regular commands
  # --------------

  def command_show(args = [])
    show = get_show(args.first)
    show_number = args[1] if args.length > 1

    if show and show_number
      reply("#{$domain}/#{show.url}/#{show_number}")
    elsif show
      reply("#{$domain}/#{show.url}")
    else
      reply("No show by name \"#{args.first}\". You dissappoint.")
      reply(usage("show"))
    end
  end

  def command_links(args = [])
    if args.length < 2
      chat(usage("links"))
    else
      show = get_show(args.first)
      show_number = args[1]

      if show and show_number and show_number.strip != ""
        reply(show.links(show_number).join("\n"))
      else
        chat(usage("links"))
      end
    end
  end

  def command_suggest(args = [])
    suggestion = args.first.strip
    if suggestion and suggestion != ""
      @@suggested_titles.push suggestion
      chat("Added title suggestion \"#{suggestion}\"")
    else
      chat(usage("suggest"))
    end
  end

  def command_suggestions(args = [])
    if @@suggested_titles.length == 0
      reply(usage("suggestions"))
    else
      chat("#{@@suggested_titles.length} titles so far:\n")
      chat(@@suggested_titles.join("\n"))
    end
  end

  def command_clear(args = [])
    if @@suggested_titles.length == 1
      chat("Clearing 1 title suggestion.")
    elsif @@suggested_titles.length == 0
      chat("There are no suggestions to clear. You can start adding some by using \"!suggest title_suggestion\".")
    else
      chat("Clearing #{@@suggested_titles.length} title suggestions.")
    end
    @@suggested_titles.clear
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
    chat("From the wise Mr. Mann: \"#{$drphil.random}\".")
  end

end
