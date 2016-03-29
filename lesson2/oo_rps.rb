#OO Rock Paper Scissors


class Player
  def initialize
    # maybe a "name"? what about a "move"?
  end

  def choose

  end
end

class Move
  def initialize
    # seems like we need something to keep track
    # of the choice... a move object can be "paper", "rock" or "scissors"
  end

  def compare

  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2)

end

RPSGame.new.play

class RPSGame
  def initialize

  end

  def play
    display_welcom_message
    human_choose_move
    computer_choose_move
    display_winner
    display_goodbye_message
  end
end
