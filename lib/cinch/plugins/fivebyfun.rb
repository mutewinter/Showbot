# The stuff that makes showbot so nice to be around.

require './lib/random.rb'

module Cinch
  module Plugins
    class FiveByFun
      include Cinch::Plugin

      # The cast
      match %r{(merlin|mann)},   :method => :command_merlin
      match %r{(sandy|sandwich|adam)},   :method => :command_sandy
      match %r{(jsir|siracusa|jsiracusa)},   :method => :command_jsir
      # The characers
      match "paleo",   :method => :command_paleo
      match "drphil",   :method => :command_drphil
      match %r{(eight_ball|8ball)},   :method => :command_eight_ball
      match %r{(dan|danbenjamin)},   :method => :command_dan
      match "robertevans",   :method => :command_robert_evans
      match "gruber",   :method => :command_gruber
      

      def command_drphil(m)
        m.reply ["There's a genie for that.",
          "Everything's a bear.",
          "A beret will be fine.",
          "If you want to find the treasure you gotta buy the chest!",
          "You don't win at tennis by buying a bowling ball.",
          "If you live in a tree, don't be surprised that you're living with monkeys.",
          "Crush the Bunny.",
          "Doesn't matter how many Fords you buy, they're never gonna be a Dodge. You can repaint the Ford but... let's go to a break.",
          "You're not gonna get Black Lung from an excel spreadsheet.",
          "I'm not gonna euthanize this dog, I'm just gonna put it over here where I can't see it.",
          "Failure is the equivalent of existential sit-ups."].random
      end


      def command_merlin(m)
        m.reply "SO angry."
      end
      
      def command_sandy(m)
        m.reply "He's great."
      end

      def command_paleo(m)
        m.reply ["You wouldn't be tired.",
        "Your insulin wouldn't be spiking.",
        "Elk.",
        "No glutens."].random
      end

      def command_jsir(m)
        m.reply ["perl -le '$n=10; $min=5; $max=15; $, = \" \"; print map { int(rand($max-$min))+$min } 1..$n'",
          "perl -le '$i=3; $u += ($_<<8*$i--) for \"127.0.0.1\" =~ /(\d+)/g; print $u'",
          "perl -MAlgorithm::Permute -le '$l = [1,2,3,4,5]; $p = Algorithm::Permute->new($l); print @r while @r = $p->next'",
          "perl -lne '(1x$_) !~ /^1?$|^(11+?)\\1+$/ && print \"$_ is prime\"'",
          "perl -ple 's/^[ \\t]+|[ \\t]+$//g'"].random
      end

      def command_gruber(m)
        m.reply "I don't know."
      end

      def command_eight_ball(m)
        m.reply ["It is certain",
          "It is decidedly so",
          "Without a doubt",
          "Yes - definitely",
          "You may rely on it",
          "As I see it, yes",
          "Most likely",
          "Outlook good",
          "Signs point to yes",
          "Yes",
          "Reply hazy, try again",
          "Ask again later",
          "Better not tell you now",
          "Cannot predict now",
          "Concentrate and ask again",
          "Don't count on it",
          "My reply is no",
          "My sources say no",
          "Outlook not so good",
          "Very doubtful"].random
      end

      def command_dan(m)
        m.reply "That's fine for Merlin."
      end

      def command_robert_evans(m)
        m.reply "You bet your ass I was."
      end

    end
  end
end

