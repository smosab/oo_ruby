require 'pry'
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    binding.pry
    self.age += 1
  end
end

whiskers = Cat.new("siamese")

whiskers.make_one_year_older

p whiskers.age
