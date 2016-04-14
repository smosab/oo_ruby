# This version is utilizing the attr_accessor and is relying on it to create the setter and getter methods for the template instance variable.
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# This version is not utilizing the attr_accessor and it can function without it because it is calling the instance variables directly 
# by using the 'self' keyword.
class Computer2
  #attr_accessor :template

  def create_template
    self.template = "template 14231" 
  end

  def show_template
    self.template
  end
end

computer = Computer.new
computer.create_template
p computer.show_template

computer2 = Computer.new
computer2.create_template
p computer2.show_template