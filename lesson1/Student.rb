#Student class

class Student
  attr_accessor :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    self.get_grade > student.get_grade
  end

  protected

  def get_grade
    @grade
  end
end

joe = Student.new("Joe", 100)
bob = Student.new("Bob", 90)


puts "Well done!" if joe.better_grade_than?(bob)

