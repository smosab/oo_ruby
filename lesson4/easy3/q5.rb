class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer #=> NoMethodError
tv.model #=> Method would be called.

Television.manufacturer #=> Method would be called.
Television.model #=> NoMethodError