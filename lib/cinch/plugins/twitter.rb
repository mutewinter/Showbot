# A Cinch plugin for broadcasting Twitter updates to an IRC channel

require 'chronic_duration'
require 'twitter'
        
module Cinch	
  module Plugins
    class Twitter
      include Cinch::Plugin

      timer 60, :method => :send_last_status

      match "last_status",   :method => :command_last_status

      Client = ::Twitter::REST::Client.new do |c|
        c.consumer_key = config[:twitter_consumer_key]
        c.consumer_secret = config[:twitter_consumer_secret]
        c.access_token = config[:twitter_access_token]
        c.access_token_secret = config[:twitter_access_token_secret]
      end

      def initialize(*args)
        super

        @user = config[:twitter_user]
        @channel = config[:channel]
        @channel_test = config[:channel_test]
        @twitter_user = nil
        @status = {}
        @last_sent_id = {}
        @user.each do |z|
          @last_sent_id[z] = nil
          @status[z] = nil
        end
      end

      def response_from_laststatus(status)
        if status
          created_at = status.created_at.to_datetime
          seconds_ago = (Time.now - created_at.to_time).to_i
          relative_time = ChronicDuration.output(seconds_ago, :format => :long)

          return "@#{@twitter_laststatus_user}: #{status.text} (#{relative_time} ago)"
        end
      end

      # Send the last status for the TWITTER_USER to the user who requested it
      def command_last_status(m)
        @user.each do |z|
          begin
            status = Client.user_timeline(z).first
            @twitter_laststatus_user = z
            m.user.send response_from_laststatus(status)
          rescue ::Twitter::Error::ServiceUnavailable
            m.user.send "Oops, looks like Twitter's whale failed. Try again in a minute."
          end
        end
      end

      def send_last_status
        @user.each do |z|
          begin
            @status[z] = Client.user_timeline(z).first
          rescue ::Twitter::Error::ServiceUnavailable
            puts "Error: Twitter is over capacity."
            return
          end

          if @last_sent_id[z].nil?
            # Skip the first message from TWITTER_USER so we don't spam every
            # time the bot reconnects
            @last_sent_id[z] = @status[z].id

          elsif @last_sent_id[z] != @status[z].id

            if @status[z].in_reply_to_status_id or @status[z].in_reply_to_screen_name
              # Don't show replies
              next
            end

            @last_sent_id[z] = @status[z].id
            status = @status[z]
            @twitter_user = z

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
end
