class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    "I want to turn on the light with a brightness level of super high and a colour of green"
  end

#   def information
#     "I want to turn on the light with a brightness level of #{brightness} and a colour of #{color}"
#   end
end

# mylight = Light.new("super high", "green")
# p mylight.information

Light.new("super high", "green")
p Light.information