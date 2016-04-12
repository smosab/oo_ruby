class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

oracle = Oracle.new

p oracle.predict_the_future # => "you will eat a nice lunch"
                            # => "you will take a nap soon"
                            # => "you will stay at work late"
                          