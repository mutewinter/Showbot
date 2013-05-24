# Adding randomize and random to Array. http://www.weheartcode.com/2006/10/06/randomizing-an-array-in-ruby/

class Array
  def randomize
    arr=self.dup
    self.collect { arr.slice!(rand(arr.length)) }
  end

  def randomize!
    self.replace self.randomize
  end

  def random
    self.randomize.first
  end

end
