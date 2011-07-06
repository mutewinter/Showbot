
# Get the title of a Shoutcast stream

require 'uri'
require 'net/http'

module Cinch
  module Plugins
    class ShoutcastInfo
      include Cinch::Plugin

      SHOUTCAST_URI = URI("http://5by5.fm/") 
      HEADERS = {
          "Icy-MetaData" => '1'
      }

      match %r{(current|live|nowplaying)},   :method => :command_current    # !current

      def initialize(*args)
        super

        @last_update = Time.now
        @show = fetch_show
      end
      
      # =========================
      # Commands
      # =========================

      def command_current(m)
        if (Time.now - @last_update) > 60
          # Data older than 60 seconds, refresh it
          @show = fetch_show
        end
        
        if @show
          m.user.send "#{@show} is streaming on 5by5.tv/live"
        else

          m.user.send "Failed to get stream info, 5by5.fm may be down. I'm sorry."
        end
      end

      # =========================
      # Helper Methods
      # =========================

      # Fetches the show title from the live stream defined by URI
      def fetch_show
        @last_update = Time.now

        http = Net::HTTP.new(SHOUTCAST_URI.host, SHOUTCAST_URI.port)

        chunk_count = 0
        chunk_limit = 20 # Limit chunks to prevent lockups
        http.get(SHOUTCAST_URI.path, HEADERS) do |chunk|
          chunk_count += 1
          if chunk =~ /StreamTitle='(.+?)'/
            return $1
            break;
          elsif chunk_count > chunk_limit
            return nil
          end
        end
      end

    end
  end
end
