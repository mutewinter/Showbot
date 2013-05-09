# A Cinch plugin for broadcasting Twitter updates to an IRC channel

require 'chronic_duration'
require 'twitter'


module Cinch
  module Plugins
    class Twitter
      include Cinch::Plugin

      timer 60, :method => :send_last_status

      match "last_status",   :method => :command_last_status

      def initialize(*args)
        super

        @channel = config[:channel]
        @channel_test = config[:channel_test]
        @twitter_user = shared[:Twitter_User]
        ::Twitter.configure do |c|
          c.consumer_key = config[:twitter_consumer_key]
          c.consumer_secret = config[:twitter_consumer_secret]
          c.oauth_token = config[:twitter_oauth_token]
          c.oauth_token_secret = config[:twitter_oauth_token_secret]
        end
        @last_sent_id = nil
      end

      # Send the last status for the TWITTER_USER to the user who requested it
      def command_last_status(m)
        begin
          status = ::Twitter.user_timeline(@twitter_user).first
          m.user.send response_from_status(status)
        rescue ::Twitter::Error::ServiceUnavailable
          m.user.send "Oops, looks like Twitter's whale failed. Try again in a minute."
        end
      end

      def send_last_status
        begin
          status = ::Twitter.user_timeline(@twitter_user).first
        rescue ::Twitter::Error::ServiceUnavailable
          puts "Error: Twitter is over capacity."
          return
        end

        if @last_sent_id.nil?
          # Skip the first message from TWITTER_USER so we don't spam every
          # time the bot reconnects
          @last_sent_id = status.id
        elsif @last_sent_id != status.id

          if status.in_reply_to_status_id or status.in_reply_to_screen_name
            # Don't show replies
            return false
          end

          @last_sent_id = status.id

          if @bot.nick =~ /_test$/
            Channel(@channel_test).send response_from_status(status)
          else
            Channel(@channel).send response_from_status(status)
          end
        end
      end

      def response_from_status(status)
        if status
          created_at = status.created_at.to_datetime
          seconds_ago = (Time.now - created_at.to_time).to_i
          relative_time = ChronicDuration.output(seconds_ago, :format => :long)

          return "@#{@twitter_user}: #{status.text} (#{relative_time} ago)"
        end
      end

    end
  end
end

