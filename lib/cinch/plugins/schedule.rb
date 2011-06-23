# Query the schedule from an iCal store

module Cinch
  module Plugins
    class Schedule
      include Cinch::Plugin
      include ShowUtils

      timer 600, method: => :refresh_calendar
      
      match %r{next (.*)},   :method => :command_next    # !next
      match %r{schedule (.*)},   :method => :command_schedule    # !schedule
      
      def initialize(*args)
        super
        @shows = Shows.new "pubilc/shows.json"
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
      def command_next(m, show)
        show = @shows.find_show(args.first) if args.length > 0

        if show
          next_event = @@events.next_event(show.title)
        else
          next_event = @@events.next_event
        end

        if next_event
          date_string = next_event.start_time.strftime("%-m/%-d/%Y")
          time_string = next_event.start_time.strftime("%-I:%M%P")
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
      # TODO support show arg for specific show's events (next 3 or so)
      def command_schedule(m, show)
        upcoming_events = @@events.upcoming_events

        if upcoming_events.length > 0
          m.user.send "#{upcoming_events.length} upcoming show#{upcoming_events.length > 1 ? "s" : ""}"
          upcoming_events.sort{|e1, e2| e1.start_time <=> e2.start_time}.each do |event|
            date_string = event.start_time.strftime("%-m/%-d/%Y")
            time_string = event.start_time.strftime("%-I:%M%P")
            m.user.send "  #{event.summary} on #{date_string} at #{time_string}"
          end
        end

      end

    end
  end
end

