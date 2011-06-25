# Admin commands for showbot

module Cinch
  module Plugins
    class ShowbotAdmin
      include Cinch::Plugin

      
      match %r{history (.*)},   :method => :command_history
      match %r{history_count (.*)},   :method => :command_history_count
      match %r{(exit|quit) (.+)},   :method => :command_exit
      
      def initialize(*args)
        super
        @admin_password = ENV['SHOWBOT_ADMIN_PASSWORD']

        if @admin_password.nil? or @admin_password.strip.empty?
          # Generate an admim key since one wasn't found
          @admin_password ||= (0...8).map{65.+(rand(25)).chr}.join
          puts "Admin key is #{@admin_password}"
        end
      end

      # Admin command that shows the recently executed commands
      # !exit @admin_password
      def command_history(m, password)
        if password == @admin_password
          # TODO reply with history from DB
        end
      end

      def command_history_count(m, password)
        if password == @admin_password
          # TODO reply with history count from DB
        end
      end

      # Admin command that tells the bot to exit
      # !exit @admin_password
      def command_exit(m, password)
        if password == @admin_password
          reply("Showbot is shutting down. Good bye :(")

          # TODO Print history here

          Process.exit
        end
      end


    end
  end
end

