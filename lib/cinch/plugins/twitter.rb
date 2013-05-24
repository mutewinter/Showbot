# A Cinch plugin for broadcasting Twitter updates to an IRC channel

require 'chronic_duration'
require 'twitter'

CHANNEL = "#5by5"
TWITTER_USER = "5by5"

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end

module Cinch
  module Plugins
    class Twitter
      include Cinch::Plugin

      timer 60, :method => :send_last_status

      match "last_status",   :method => :command_last_status

      def initialize(*args)
        super

        @last_sent_id = nil
      end

      # Send the last status for the TWITTER_USER to the user who requested it
      def command_last_status(m)
        begin
          status = ::Twitter.user_timeline(TWITTER_USER).first
          m.user.send response_from_status(status)
        rescue ::Twitter::Error::ServiceUnavailable
          m.user.send "Oops, looks like Twitter's whale failed. Try again in a minute."
        end
      end

      def send_last_status
        begin
          status = ::Twitter.user_timeline(TWITTER_USER).first
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
            Channel("#cinch-bots").send response_from_status(status)
          else
            Channel(CHANNEL).send response_from_status(status)
          end
        end
      end

      def response_from_status(status)
        if status
          created_at = status.created_at.to_datetime
          seconds_ago = (Time.now - created_at.to_time).to_i
          relative_time = ChronicDuration.output(seconds_ago, :format => :long)

          return "@#{TWITTER_USER}: #{status.text} (#{relative_time} ago)"
        end
      end

    end
  end
end

