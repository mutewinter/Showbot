# Showbot

A sweet IRC bot for [5by5](http://5by5.tv). Built on [cinch](https://github.com/ymendel/cinch/blob/master/lib/cinch/base.rb).

## Requirements

* Ruby 1.9
* [cinch gem](http://rubygems.org/gems/cinch)
* [ri_cal](http://rubygems.org/gems/ri_cal)
* [chronic_duration gem](http://rubygems.org/gems/chronic_duration)

## Commands

* next
<pre>
!next
showbot> Next show is Build and Analyze in 17 hours 30 minutes 35 seconds (05/30/2011)
* show 
<pre>
!show b2w 12
showbot> http://5by5.tv/b2w/12
</pre>
* titles
<pre>
!titles b2w
showbot> 16: Bracing for the Blow
15: Marionette of my own Design
14: Velocity of Disappointment
13: The Kid's Great
12: Chewie's Medal is Not Canonical
11: Johnny Heuristic
10: At Last the 'Inspiration' Show
9: Out of Scope!
8: Little Velvet Hands
7: Vocational Wheel
6: Expectational Debt
5: Chigger Bites on the Bus Driver
4: Failing with Style
3: The Second Arrow
2: Picture of a Boat
1: Alligator in the Bathroom
</pre>
</pre>
* description
<pre>
!description b2w 8
showbot> This week, Merlin Mann and Dan Benjamin eighty-six their
restaurant jobs?emptying grease traps, handling logs of meat, and sharing what
they learned by bringing mostly bad food to America's table. Dan burns velvet
hands, Merlin's Mom gives the guy with th
</pre>
* links
<pre>
links b2w 1
showbot> Welcome to BrettTerpstra.com, home of Brett Terpstra and his nerdery - http://brettterpstra.com/
carlhuda/janus ? GitHub - https://github.com/carlhuda/janus
practically efficient ? technology, workflows, life - http://www.practicallyefficient.com/
MacSparky ? Blog - http://www.macsparky.com/
The Brooks Review - http://brooksreview.net/
And now it?s all this - http://www.leancrew.com/all-this/
Dan Rodney?s List of Mac OS X Keyboard Shortcuts & Keystrokes - http://www.danrodney.com/mac/
43f Podcast: John Gruber & Merlin Mann?s Blogging Panel at SxSW | 43 Folders - http://www.43folders.com/2009/03/25/blogs-turbocharged
waffle software ? ThisService - http://wafflesoftware.net/thisservice/
One Thing Well - http://onethingwell.org/
html2text: THE ASCIINATOR (aka html2txt) - http://www.aaronsw.com/2002/html2text/
The Conversation #27: Missionless Statements ? 5by5 - http://5by5.tv/conversation/27
Smash into Vim [Screencast] - http://peepcode.com/products/smash-into-vim-i
</pre>
* suggest
<pre>
!suggest Awesome Show Title
showbot> Added title suggestion 'Awesome Show Title'
</pre>
* suggestions
<pre>
!suggestions
showbot>
3 titles so far:
Awesome Show Title
Big Bad Tacos
Almost Time to Poop
</pre>
* clear
<pre>
!clear
Clearing 3 title suggestions
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
