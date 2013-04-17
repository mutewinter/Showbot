# Admin commands for showbot

module Cinch
  module Plugins
    class Admin
      include Cinch::Plugin

      timer 300, :method => :fix_name

      match %r{(?:exit|quit) (.+)},   :method => :command_exit

      def initialize(*args)
        super
        @admin_password = ENV['SHOWBOT_ADMIN_PASSWORD']

        if @admin_password.nil? or @admin_password.strip.empty?
          # Generate an admim key since one wasn't found
          @admin_password ||= (0...8).map{65.+(rand(25)).chr}.join
          puts "Admin key is #{@admin_password}"
        end
      end

      # Admin command that tells the bot to exit
      # !exit @admin_password
      def command_exit(m, password)
        if password == @admin_password
          m.user.send "Showbot is shutting down. Good bye :("

          Process.exit
        else
          puts "Wrong admin password (#{password}), should be #{@admin_password}"
        end
      end

      # Called every 5 minutes to attempt to fix showbot's name.
      # This can happen if showbot gets disconnected and reconnects before
      # the last bot as been kicked from the IRC server.
      def fix_name
        if @bot.nick == "showbot" or @bot.nick == "showbot_test"
          puts "Nick is fine, no change necessary."
        else
          puts "Fixing nickname."
          @bot.nick = "showbot"
        end
      end

    end
  end
end

