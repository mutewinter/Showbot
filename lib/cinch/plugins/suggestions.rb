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
        # Remove quotes if the user thought they needed them
        title.gsub!(/^(?:'|")(.*)(?:'|")$/, '\1')

        if title.empty?
          command_help(m)
        elsif title.length > Suggestion.title.length
            m.user.send "Suggestion NOT recorded. Showbot is sorry. Think title, not transcript."
        else
          # TODO Save show from URL
          new_suggestion = Suggestion.create(
            :title      => title,
            :user       => m.user.nick,
            :created_at => Time.now
          )

          if new_suggestion.saved?
            m.user.send "Added title suggestion \"#{title}\""
          else
            m.user.send "Failed to add title suggestion, please contact @mutewinter on Twitter if this keeps happening."
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

