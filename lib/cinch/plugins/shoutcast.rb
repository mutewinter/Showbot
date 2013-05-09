
# Get the title of a Shoutcast stream

require 'uri'
require 'net/http'

module Cinch
  module Plugins
    class Shoutcast
      include Cinch::Plugin

      HEADERS = {
          "Icy-MetaData" => '1'
      }

      match %r{(current|live|nowplaying)},   :method => :command_current    # !current

      def initialize(*args)
        super

        @shoutcast_uri = URI(config[:shoutcast_uri])
        @last_update = Time.now
        @shoutcast_show = parse_shoutcast_stream
      end

      # =========================
      # Commands
      # =========================

      def command_current(m)
        if (Time.now - @last_update) > 60
          # Data older than 60 seconds, refresh it
          @shoutcast_show = parse_shoutcast_stream
        end

        live_show = Shows.fetch_live_show
        if @shoutcast_show
          m.user.send "#{@shoutcast_show} is streaming on 5by5.tv/live"
        elsif live_show
          m.user.send "#{live_show.title} is live right now!"
        else
          m.user.send "Failed to get stream info, 5by5.fm may be down. I'm sorry."
        end
      end

      # =========================
      # Helper Methods
      # =========================

      # Fetches the show title from the live stream defined by URI
      def parse_shoutcast_stream
        @last_update = Time.now

        http = Net::HTTP.new(@shoutcast_uri.host, @shoutcast_uri.port)

        chunk_count = 0
        chunk_limit = 20 # Limit chunks to prevent lockups
        begin
          http.get(@shoutcast_uri.path, HEADERS) do |chunk|
            chunk_count += 1
            if chunk =~ /StreamTitle='(.+?)';/
              return $1
              break;
            elsif chunk_count > chunk_limit
              return nil
            end
          end
        rescue Exception => e
          puts "Shoucast stream parse failed with message:\n"
          puts e.message
        end

        # Just in case we get an HTTP error
        return nil
      end

    end
  end
end
