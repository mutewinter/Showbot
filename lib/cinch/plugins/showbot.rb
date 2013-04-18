# Commands that didn't belong anywhere else

require 'chronic_duration'

module Cinch
  module Plugins
    class Showbot
      include Cinch::Plugin

      match %r{(help|commands)$},  :method => :command_help     # !help
      match %r{(about|showbot)},   :method => :command_about    # !about
      match "uptime",   :method => :command_uptime              # !uptime

      def initialize(*args)
        super
        @start_time = Time.now
      end

      # Show help for the suggestions module
      def command_help(m)
        m.user.send [
          "!next - When's the next live show?",
          "!schedule - What shows are being recorded live in the next seven days?",
          "!suggest - Be heard. Suggest a title for the live show.",
          "!link - Know the link for that? Suggest it and make the show better.",
          "!current - What's playing on 5by5.tv/live? I've got you covered.",
          "!last_status - The last tweet by @5by5, delievered to you in IRC. Sweet.",
          "!about - Was showbot coded or did it spontaniously come into existence?",
          "!help - Uh, this.",
        ].join("\n")
      end

      # Show information about showbot
      def command_about(m)
        m.user.send "Showbot was created by Jeremy Mack (@mutewinter) and some awesome contributors on github. The project page is located at https://github.com/mutewinter/Showbot"
        m.user.send "Type !help for a list of showbot's commands"
      end

      # Tell them where to find the lovely suggestions
      def command_uptime(m)
        date_string = @start_time.strftime("%-m/%-d/%Y")
        time_string = @start_time.strftime("%-I:%M%P")
        seconds_running = (Time.now - @start_time).to_i
        m.user.send "Showbot has been running for " +
          "#{ChronicDuration.output(seconds_running, :format => :long)} " +
          "since #{date_string} at #{time_string}"
      end

    end
  end
end

