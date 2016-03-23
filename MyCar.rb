# MyCar class

#
class MyCar
  attr_accessor :speedup, :brake, :shut_off, :color
  attr_reader :year

  def self.calc_gas_mileage(miles_driven, gallons_used)
    gas_mileage = miles_driven / gallons_used

    puts "Your car gets #{gas_mileage} miles to the gallon"
  end

  def initialize(y, c, m, s = 0)
    @year = y
    @color = c
    @model = m
    @speed = s
  end

  def spray_paint=(color)
    @color = color
  end

  def to_s
    puts "You have a #{@color} #{@year} #{@model}"
  end
end

MyCar.calc_gas_mileage(300, 12)

myride = MyCar.new(2016, "Platinum Grey", "Jetta GLI")

puts myride

