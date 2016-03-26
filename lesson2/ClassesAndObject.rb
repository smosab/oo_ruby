require 'pry'
#1,2

class Person
  attr_accessor :name, :last_name, :first_name

  def initialize(full_name)
    parse_fullname(full_name)
  end

  def name
    self.first_name.to_s + ' ' + self.last_name.to_s
  end

  def name=(full_name)
    parse_fullname(full_name)
  end

  private

  def parse_fullname(full_name)
    self.last_name = full_name.split[1]
    self.first_name = full_name.split[0]
  end

  def to_s
    name
  end
end

# bob = Person.new('bob')
# p bob.name                  # => 'bob'
# bob.name = 'Robert'
# p bob.name                  # => 'Robert'

# bob = Person.new('Robert')
# p bob.name                  # => 'Robert'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# bob.last_name = 'Smith'
# p bob.name                  # => 'Robert Smith'

# bob.name = "John Adams"
# p bob.first_name            # => 'John'
# p bob.last_name             # => 'Adams'

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"