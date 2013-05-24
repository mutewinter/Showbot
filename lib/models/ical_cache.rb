# Wrapper class for ri_cal that caches the data
# and handles some advanced queries

require "ri_cal"
require "open-uri"
require 'tzinfo'

class ICalCache

  # Takes the target iCal url as an argument
  def initialize(ical_url)
    @ical_url = ical_url
    refresh
  end

  # Refreshes the cache
  def refresh
    begin
      @cache = RiCal.parse(open(@ical_url))
    rescue OpenURI::HTTPError
      puts "#{Time.now} ERROR: Failed to fetch calendar data. OpenURI::HTTPError"
    end
  end


  # Return the next iCal event after the current time
  def next_event(keyword = nil)
    nearest_event = nil
    nearest_seconds_until = nil

    upcoming_events.each do |event|
      # Grab the next occurrence for the event
      event = (event.occurrences({:starting => DateTime.now, :count => 1})).first

      if event and event.start_time > DateTime.now
        seconds_until = ((event.start_time - DateTime.now) * 24 * 60 * 60).to_i
        if keyword and event.summary.strip.downcase.include? keyword.downcase
          if !nearest_seconds_until
            nearest_seconds_until = seconds_until
            nearest_event = event
          elsif seconds_until < nearest_seconds_until
            nearest_seconds_until = seconds_until
            nearest_event = event
          end
        elsif !keyword
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

    nearest_event
  end

  # Return an array of iCal events for today onward
  def upcoming_events
    events = []

    @cache.first.events.each do |event|
      # Grab the next occurrence for the event
      event = (event.occurrences({:starting => Date.today, :count => 1})).first

      if event
        skip = false
        events.reject do |e|
          if e.uid == event.uid
            if e.last_modified < event.last_modified
              # Remove old event if same UID and older modified time
              true
            else
              # Don't add the new event because it was modified longer ago than current
              skip = true
            end
          else
            false
          end
        end

        events << event if not skip
      end
    end
    events
  end

end
