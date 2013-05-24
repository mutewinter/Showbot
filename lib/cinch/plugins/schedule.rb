# Query the schedule from an iCal store

require 'chronic_duration'
require './lib/models/shows'
require './lib/models/ical_cache'

module Cinch
  module Plugins
    class Schedule
      include Cinch::Plugin

      timer 600, :method => :refresh_calendar

      match /next\s?(.*)/i,     :method => :command_next      # !next
      match /schedule\s?(.*)/i, :method => :command_schedule  # !schedule

      def initialize(*args)
        super
        # This is a terrible hack to get access to a folder in the project directory
        # TODO find a better way
        @calendar = ICalCache.new "http://www.google.com/calendar/ical/fivebyfivestudios%40gmail.com/public/basic.ics"
        # Get the inital data for the calendar
        refresh_calendar
      end

      # Refreshes calendar data
      def refresh_calendar
        puts "Refreshing calendar data"
        @calendar.refresh
      end

      # Replies to the user with information about the next show
      # !next b2w -> The next Back to Work is in 3 hours 30 minutes (6/2/2011)
      def command_next(m, show_keyword)
        show = Shows.find_show(show_keyword) if show_keyword and !show_keyword.strip.empty?

        if show
          next_event = @calendar.next_event(show.title)
        else
          next_event = @calendar.next_event
        end

        if next_event
          tz = TZInfo::Timezone.get('America/New_York')
          time = tz.utc_to_local(next_event.start_time)

          date_string = time.strftime("%A, %-m/%-d/%Y")
          time_string = time.strftime("%-I:%M%P EST")
          nearest_seconds_until = ((next_event.start_time - DateTime.now) * 24 * 60 * 60).to_i
          if show
            m.user.send "The next #{next_event.summary} is in #{ChronicDuration.output(nearest_seconds_until, :format => :long)} (#{time_string} on #{date_string})"
          else
            m.user.send "Next show is #{next_event.summary} in #{ChronicDuration.output(nearest_seconds_until, :format => :long)} (#{time_string} on #{date_string})"
          end
        else
          m.user.send "No upcoming show found for #{show.title}"
        end

      end

      # Replies with the schedule for the next 7 days of shows
      def command_schedule(m, command)
        upcoming_events = @calendar.upcoming_events

        if command == "refresh"
          refresh_calendar
        elsif upcoming_events.length > 0
          m.user.send "#{upcoming_events.length} upcoming show#{upcoming_events.length > 1 ? "s" : ""}"
          upcoming_events.sort{|e1, e2| e1.start_time <=> e2.start_time}.each do |event|
            tz = TZInfo::Timezone.get('America/New_York')
            time = tz.utc_to_local(event.start_time)
            date_string = time.strftime("%A, %-m/%-d/%Y")
            time_string = time.strftime("%-I:%M%P EST")
            m.user.send "  #{event.summary} on #{date_string} at #{time_string}"
          end
        end

      end

    end
  end
end

