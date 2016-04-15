class SecretFile
  attr_reader :access_log # :data


  def initialize(secret_data)
    @data = secret_data
    @access_log = []
  end

  def get_data
    logger = SecurityLogger.new
    @access_log << logger.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
    Time.now
  end
end

myfile = SecretFile.new("shhhhh")

p myfile.get_data
p myfile.access_log


