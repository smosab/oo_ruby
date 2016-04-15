class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  # Adding a play method in this class will override the play method in the Game class.
end