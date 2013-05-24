# The stuff that makes showbot so nice to be around.

require './lib/random.rb'

module Cinch
  module Plugins
    class FiveByFun
      include Cinch::Plugin

      # The cast
      match /(dan|danbenjamin)/i,         :method => :command_dan
      match /(haddie|haddiebird)/i,       :method => :command_haddie
      match /(merlin|mann)/i,             :method => :command_merlin
      match /(sandy|sandwich|adam)/i,     :method => :command_sandy
      match /(jsir|siracusa|jsiracusa)/i, :method => :command_jsir
      match /marco/i,                     :method => :command_marco
      match /gruber/i,                    :method => :command_gruber
      match /robertevans/i,               :method => :command_robert_evans
      match /faith/i,                     :method => :command_faith
      match /(mike|monteiro)/i,           :method => :command_mike
      match /(roderick)/i,                :method => :command_roderick
      # The characters
      match /drphil/i,                    :method => :command_drphil
      match /(vanhoet|neckbeard)/i,       :method => :command_van_hoet
      match /paleo/i,                     :method => :command_paleo
      match /glen/i,                      :method => :command_glengarry
      match /usa/i,                       :method => :command_usa
      match /turd/i,                      :method => :command_turd
      match /resp/i,                      :method => :command_responsibility
      match /(lebowski|dude)/i,           :method => :command_lebowski
      match /(texas)/i,                   :method => :command_texas
      match /(ferris|bueller)/i,          :method => :command_bueller
      match /bluetoot/i,                  :method => :command_bluetoot
      match /sodastream/i,                :method => :command_sodastream
      match /(aviator|future)/i,          :method => :command_aviator
      # The etc.
      match /lemongrab/i,                 :method => :command_lemongrab
      match /peppermint_butler/i,         :method => :command_peppermint
      match /(eight_ball|8ball)/i,        :method => :command_eight_ball
      match /(quit)/i,                    :method => :command_quit_show

      def command_glengarry(m)
        m.reply ["You got leads. Mitch and Murray paid good money. Get their names to sell them.",
          "I'm here from downtown. I'm here from Mitch and Murray.",
          "Get them to sign on the line which is dotted!",
          "Attention. Do I have your attention? Interest. Are you interested? I know you are 'cause it's fuck or walk. You close or you hit the bricks. Decision. Have you made your decision for Christ? And action.",
          "Oh yeah, I used to be a salesman. It's a tough racket.",
          "Second prize is a set of steak knives. Third prize is you're fired.",
          "Coffee's for closers only."
          ].random
      end

      def command_usa(m)
        m.reply "USA! USA! USA! USA! USA! USA!"
      end

      def command_turd(m)
        m.reply "You can't. Polish. A turd."
      end

      def command_responsibility(m)
        m.reply ["Have you ever had a single moment's thought about my responsibilities?",
          "Have you ever thought for a single solitary moment about my responsibilities to my employers?",
          "Has it ever occurred to you that I have agreed to look after the Overlook Hotel until May the First?",
          "Does it matter to you at all that the owners have placed their complete confidence and trust in me, and that I have signed a letter of agreement",
          "A CONTRACT!",
          "Do you have the slightest idea what a moral and ethical principle is?",
          "Has it ever occurred to you what would happen to my future if I were to fail to live up to my responsibilities?",
          ].random
      end

      def command_lebowski(m)
        m.reply ["That's your name, Dude!",
          "I see you rolled your way into the semis. Dios mio, man.",
          "Uh, uh, papers, um, just papers, uh, you know, uh, my papers, business papers."
          ].random
      end

      def command_texas(m)
        m.reply "The stars at night are big and bright..."
      end

      def command_bluetoot(m)
        m.reply ["Hi! Can I aks you a queshion?",
        "Before you answer, Hi!"
        ].random
      end

      def command_sodastream(m)
        m.reply "pshhh pshhh pshhh HONNNNKKKK HONNNNKKKK HONNNNKKKK"
      end

      def command_bueller(m)
        m.reply ["Nine times?",
          "Nine times.",
          "ok I'll go, I'll go, I'll go, I'll go, I'll go."
        ].random
      end

      def command_aviator(m)
        m.reply ["The way of the future.",
          "Come in with the milk. Come in with the milk. Come in with the milk."
        ].random
      end

      def command_roderick(m)
        m.reply ["I demand satisfaction!",
        "I agree to nothing!",
        "Supertrain will fix all of this.",
        "Keep moving and get out of the way",
        "Hitler"].random
      end

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
        m.reply ["SO angry.",
        "Don't be creepy.",
        "Go ahead, caller.",
        "Is this what people tune in for?",
        "I love you.",
        "Recursion. Which is also known as recursion.",
        "...Cleric...",
        "I gotta go bust a tinkie."
        ].random
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
        m.reply '...'
        min_sleep = 3
        max_sleep = 10
        sleep(rand(max_sleep-min_sleep) + min_sleep)
        m.reply "I don't know."
      end

      def command_lemongrab(m)
        m.reply ["This castle is in...unacceptable...condition! UNACCEPTABLE!!!",
          "All of you. Dungeon. Seven years. No trials.",
          "Three. Hours. Dungeon.",
          "Oooonnne MILLION YEARS DUNGEON!!!",
          "Who did...the thing?!",
          "Yes, of course.",
          "Ahhhhh....HAHAHAHAHAHAHAHA!",
          "I determine what is early and what is late, Mr. Peppermint.",
          "Me too. I'm excited, too."].random
      end

      def command_peppermint(m)
        m.reply ["Hey man, calm down! It's just a prank, man! For laughs!",
          "I'm excited by this meal I made!"].random
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

      def command_quit_show(m)
        m.reply "Call in to Quit! Live at (512) 518-5714. Leave a Voicemail at (512) 222-8141."
      end

      def command_dan(m)
        m.reply [ "That's fine for Merlin.",
        "Big week. Huge week.",
        "It's your show.",
        "Go ahead caller.",
        "Keeping you up, Haddie?"].random
      end

      def command_haddie(m)
        m.reply [ "That's meat, I know it.",
        "Oh, it's fabulous.",
        "No, no, no one's screwing a hole",
        "It's a sensation",
        "Eww, the cat is weird",
        "We have to worry about space germs too. Ughhhhhhhhh! Why?!?!"
        ].random
      end

      def command_robert_evans(m)
        m.reply "You bet your ass I was."
      end

      def command_van_hoet(m)
        m.reply "Erm, so."
      end

      def command_marco(m)
        m.reply ["Please don't email me.",
                 "I shouldn't have said that.",
                 "Braaaaands"].random
      end

      def command_faith(m)
        m.reply [ "Don't tweet me.",
                  "Don't be mean."].random
      end

      def command_mike(m)
        m.reply "F*ck you. Pay me."
      end

    end
  end
end

