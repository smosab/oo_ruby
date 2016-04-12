class Cube
  attr_reader :volume
  
  def initialize(volume)
    @volume = volume
  end
  
  def get_volume
    @volume
  end
end

mycube = Cube.new("16")
p mycube.volume
p mycube.get_volume
p mycube.instance_variable_get("@volume")