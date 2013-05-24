# links.rb
#
# Cinch plugin to gather links from IRC and put them in a database
#
# Gotta link 'em all

require 'addressable/uri'

module Cinch
  module Plugins
    class Links
      include Cinch::Plugin

      match /(?:link|l) (.+)/i,  :method => :command_link  # !link http://audacious_thunderbolt.org/islate
      match "links",             :method => :command_links # !links Show where the user can go to see links
      match "help link",         :method => :command_help  # !help link


      # Show help for the suggestions module
      def command_help(m)
        m.user.send "Suggest a relevant link for the current show."
        m.user.send "  Usage: !link http://audacious_thunderbolt.org/islate"
      end

      # Add the user's link to the database
      def command_link(m, uri_string)
        if uri_string.empty?
          command_help(m)
        else
          # Verify this is a valid URI
          uri = Addressable::URI::parse(uri_string)

          if uri.scheme.nil?
            # No scheme for URI, parse it again with http in front
            uri = Addressable::URI.parse("http://#{uri.to_s}")
          end

          new_link = Link.create(
            :uri  => uri,
            :user => m.user.nick
          )

          if new_link.saved?
            m.user.send "Added link suggestion #{new_link.uri}"
          else
            new_link.errors.each do |e|
              m.user.send e.first
            end
          end
        end

      end

      # Tell them where to find the lovely links
      def command_links(m)
        m.user.send 'Go to http://showbot.me/links to see the link suggestions.'
      end

    end
  end
end

