# MyCar class

module Towable
  def can_tow?(pounds)
    pounds < 2000 ? 'Yes' : 'No'
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :model, :year

  @@number_of_objects = 0

  def initialize(y, c, m, s = 0)
    @year = y
    @color = c
    @model = m
    @speed = s
    @@number_of_objects += 1
  end

  def car_info
    "You have a #{@color} #{@year} #{@model}"
  end

  def self.calc_gas_mileage(miles_driven, gallons_used)
    gas_mileage = miles_driven / gallons_used

    puts "Your car gets #{gas_mileage} miles to the gallon"
  end

  def self.total_num_of_objects
    @@number_of_objects
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    puts "You push the brake and decelerate #{number} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def shut_down
    puts "Let's park this bad boy!"
  end

  def spray_paint=(color)
    @color = color
  end

  def age
    "Your #{self.model} is #{calc_age_of_car} year(s) old"
  end

  private

  def calc_age_of_car
    year = Time.new.year
    age = year - self.year
  end
end


class MyCar < Vehicle
  attr_accessor :speedup, :brake, :shut_off

  MOTOR = "2.0 Turbo"
end

class MyTruck < Vehicle
  include Towable
  MOTOR = "5.0 V8"
end

mactruck = MyTruck.new(1975, "black", "mactruck")


# MyCar.calc_gas_mileage(300, 12)

myride = MyCar.new(2016, "Platinum Grey", "Jetta GLI")

puts mactruck.age

# puts Vehicle.ancestors
# puts MyTruck.ancestors
# puts MyCar.ancestors

# puts mactruck.car_info
# puts mactruck.can_tow?(1800)
# puts Vehicle.total_num_of_objects


