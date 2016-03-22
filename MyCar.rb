# MyCar class

#
class MyCar
  attr_accessor :speedup, :brake, :shut_off, :color
  attr_reader :year

  def initialize(y, c, m, s = 0)
    @year = y
    @color = c
    @model = m
    @speed = s
  end

  def spray_paint=(color)
    @color = color
  end
end
