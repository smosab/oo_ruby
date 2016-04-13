class Cat
  @@cats_count = 0 # what does this do? It keeps track of the number of Cat instances that have been created.

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

mycat = Cat.new("kitty cat")
yourcat = Cat.new("pussy cat")
hercar = Cat.new("alley cat")

#There should now be 3 in the @@cats_count class variable.

p Cat.cats_count