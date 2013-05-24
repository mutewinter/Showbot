# All suggestions welcome.

module Cinch
  module Plugins
    class Suggestions
      include Cinch::Plugin

      match "help suggest",        :method => :command_help        # !help suggest
      match /(?:suggest|s) (.+)/i, :method => :command_suggest     # !suggest Great Title Here


      # Show help for the suggestions module
      def command_help(m)
        m.user.send "Usage: !suggest Sweet Show Title"
      end

      # Add the user's suggestion to the database
      def command_suggest(m, title)
        if title.empty?
          command_help(m)
        else
          new_suggestion = Suggestion.create(
            :title      => title,
            :user       => m.user.nick
          )

          if new_suggestion.saved?
            m.user.send "Added title suggestion \"#{new_suggestion.title}\""
          else
            new_suggestion.errors.each do |e|
              m.user.send e.first
            end
          end
        end

      end

    end
  end
end

