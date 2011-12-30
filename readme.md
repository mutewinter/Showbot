# Showbot

A sweet IRC bot with a **web interface** for [5by5](http://5by5.tv). 
Built on [cinch](https://github.com/cinchrb/cinch) and [sinatra](http://www.sinatrarb.com/).

## Showbot on the Internets

[Showbot's Stats on GitEgo](http://gitego.com/mutewinter/Showbot)

[The Creation of Showbot](http://pileofturtles.com/2011/07/showbot/)

[Showbot.me](http://showbot.me)

## IRC Commands

* !next - When's the next live show?
* !schedule - What shows are being recorded live in the next seven days?
* !suggest - Be heard. Suggest a title for the live show.
* !link - Know the link for that? Suggest it and make the show better.
* !current - What's playing on 5by5.tv/live? I've got you covered.
* !last_status - The last tweet by @5by5, delievered to you in IRC. Sweet.
* !about - Was showbot coded or did it spontaniously come into existence?
* !help - Uh, this.

## Development

### How to make Showbot go

<pre>
$> foreman start -f Procfile.local
</pre>

_Note: This will connect the test bot to IRC and start a local web server._

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

