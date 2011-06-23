# All suggestions welcome.

module Cinch
  module Plugins
    class Suggestions
      include Cinch::Plugin

      match "help suggest", :method => :command_help           # !help suggest
      match %r{suggest (.+)},   :method => :command_suggest    # !suggest Great Title Here
      match "suggestions",   :method => :command_suggestions    # !suggest Great Title Here
      

      # Show help for the suggestions module
      def command_help(m)
        m.user.send "Usage: !suggest Sweet Show Title"
      end

      # Add the user's suggestion to the database
      def command_suggest(m, title)
        fixed_title = title.gsub(/^(?:'|")(.*)(?:'|")$/, '\1')

        if fixed_title.empty?
          command_help(m)
        end

        # TODO Some crazy code here to put suggestion in database

        m.user.send "Added title suggestion \"#{fixed_title}\""
      end

      # Tell them where to find the lovely suggestions
      def command_suggestions(m)
        m.user.send 'Go to http://showbot.me to see the title suggestions.'
      end

    end
  end
end

