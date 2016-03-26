module  Swim
  def swim
    'swimming!'
  end
end

class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def fetch
    'fetching!'
  end
end

# teddy = Dog.new

# puts teddy.speak
# puts teddy.swim

class Bulldog < Dog
  def swim
    'can\'t sim!'
  end
end

# sparky = Bulldog.new

# puts sparky.swim
# puts sparky.speak

class Fish
  include Swim
  # ... rest of class omitted
end


class Cat < Pet
  include Swim

  def speak
    "meow!"
  end
end

# wiskers = Cat.new
# puts wiskers.run
# puts wiskers.speak

# p Bulldog.ancestors

blue = Fish.new
puts blue.swim
p Fish.ancestors