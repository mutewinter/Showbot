# Showbot

A sweet IRC bot for [5by5](http://5by5.tv). Built on [cinch](https://github.com/ymendel/cinch/blob/master/lib/cinch/base.rb).

## Requirements

* Ruby 1.9
* [cinch gem](http://rubygems.org/gems/cinch)
* [ri_cal](http://rubygems.org/gems/ri_cal)
* [chronic gem](http://rubygems.org/gems/chronic)
* [nokogiri gem](http://rubygems.org/gems/nokogiri)
* [chronic_duration gem](http://rubygems.org/gems/chronic_duration)

## Commands

* !about
<pre>
showbot> !about
Showbot was created by Jeremy Mack (@mutewinter) and some awesome contributors on github. The project page is located at https://github.com/mutewinter/Showbot
Type !commands for showbot's commands
</pre>
* !commands
<pre>
showbot> !commands
Available commands:
  !about - Who made this?
  !description - !description show_name episode_number
  !suggest - !suggest title_suggestion
  !suggestions - !suggestions [show|relative_time (e.g. 3 hours ago)]
  !suggestion_count - Replies with the number of title suggestions showbot has collected.
  !next - !next [show_name]
  !schedule - Prints a list of upcoming shows on 5by5
</pre>
* !next
<pre>
!next
showbot> Next show is Build and Analyze in 17 hours 30 minutes 35 seconds (05/30/2011)
* show 
</pre>
* !schedule
<pre>
showbot> !schedule
8 upcoming shows
  Build and Analyze on 6/7/2011 at 10:00am
  Back to Work on 6/7/2011 at 2:00pm
  The Talk Show on 6/8/2011 at 2:00pm
  The Talk Show on 6/8/2011 at 5:00pm
  Hypercritical on 6/9/2011 at 9:30am
  Hypercritical on 6/10/2011 at 2:00pm
  Build and Analyze on 6/13/2011 at 2:00pm
  Big Web Show on 6/16/2011 at 3:00pm
</pre>
* !suggest
<pre>
!suggest Awesome Show Title
showbot> Added title suggestion 'Awesome Show Title'
</pre>
* !suggestions
<pre>
!suggestions
showbot>
3 titles so far:
Awesome Show Title
Big Bad Tacos
Almost Time to Poop
</pre>
* !suggestion_count
<pre>
showbot> !suggestion_count
There currently 4 suggestions.
</pre>
* !description
<pre>
!description b2w 8
showbot> This week, Merlin Mann and Dan Benjamin eighty-six their
restaurant jobs?emptying grease traps, handling logs of meat, and sharing what
they learned by bringing mostly bad food to America's table. Dan burns velvet
hands, Merlin's Mom gives the guy with th
</pre>

## License

The MIT License

Copyright (c) 2011 Jeremy Mack, Pile of Turtles, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
