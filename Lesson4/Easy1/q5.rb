# The Pizza class.
# An instance variable is defined using a single "@" sign as the first character.

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  attr_accessor :name
    
  def initialize(name)
    @name = name
  end
end

apple = Fruit.new("granny smith")
p apple.instance_variables

mypizza = Pizza.new("cheese pizza")
p mypizza.instance_variables

p mypizza.name