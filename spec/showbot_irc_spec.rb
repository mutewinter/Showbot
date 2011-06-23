describe 'main application' do
  include Rack::Test::Methods

  specify "should add suggestions awesomely" do
    @commands = Commands.new(nil, @@shows)

    @commands.run("suggest", ["Medium title here, hi."])
    @commands.run("suggest", ["This is a huge title with lowercase caps thank god."])
    @commands.run("suggest", ["Two line title hopefully here."])
    @commands.run("suggest", ["Title"])
    # XSS Test
    @commands.run("suggest", [%Q{';alert(String.fromCharCode(88,83,83))//\';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>}])
  end

  # Runs tests
  specify "should test all the commands like a boss" do
    @commands = Commands.new(nil, @@shows)

    puts "\n============Should Work=============="
    @commands.run("commands", [])
    @commands.run("about", [])
    @commands.run("next", [])
    @commands.run("next", ["b2w"])
    @commands.run("schedule", [])
    @commands.run("description", ["talkshow", "10"])
    @commands.run("history", [@commands.admin_key, "10"])

    puts "\n============Should Work (Suggestions)=============="
    @commands.run("suggest", ["Chickens and Ex-Girlfriends"])
    @commands.run("suggest", ["The Programmer Barn"])
    @commands.run("suggest", ["The Bridges of Siracusa County"])
    @commands.run("suggestions", [])
    @commands.run("suggestions", ["5 minutes ago"])

    puts "\n============Should Fail (Suggestions)=============="
    @commands.run("suggestions", ["in 2 hours"])
    @commands.run("suggestions", ["tacos"])

    puts "\n============Should Work (Clearing Suggestions)=============="
    @commands.run("clear", [@commands.admin_key])

    puts "\n============Should Fail (Out of range)=============="
    @commands.run("description", ["the pipeline", "500"])

    puts "\n============Should Fail (Regular)=============="
    @commands.run("taco", [])
    @commands.run("description", ["Waffle City", "10"])

    puts "\n============Should Work=============="
    @commands.run("uptime", [])
  end

end

