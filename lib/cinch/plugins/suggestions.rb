# All suggestions welcome.

module Cinch
  module Plugins
    class Suggestions
      include Cinch::Plugin

      match "help suggest",        :method => :command_help        # !help suggest
      match /(?:suggest|s) (.+)/i, :method => :command_suggest     # !suggest Great Title Here
      match "suggestions",         :method => :command_suggestions # !suggestions
      

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

      # Tell them where to find the lovely suggestions
      def command_suggestions(m)
        if development?
          Suggestion.all.each_with_index do |suggestion, i|
            m.user.send "[#{i+1}]: #{suggestion.title} (#{suggestion.user})]"
          end
        else
          m.user.send 'Go to http://showbot.me to see the title suggestions.'
        end
      end

    end
  end
end

